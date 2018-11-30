//
//  ListViewController.swift
//  StarWarsExplorer
//
//  Created by Максим Скрябин on 30/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import UIKit

import RealmSwift

class ListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var showingSaved: Bool = false
    var persons: [Person] = []
    var pages: [String?] = []
    var personResults: Results<Person>!
    var personNotificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupTableView()
    }
    
    @objc func deleteAllButtonTapped() {
        let yes = UIAlertAction(title: "Да, удалить", style: .destructive, handler: { _ in
            DBManager.deletePersons(Array(self.personResults))
        })
        showAlert(title: "Удалить?", body: "Вы уверены, что хотите удалить всех персонажей?", button: "Нет, отменить", actions: [yes])
    }
    
    @objc func savedButtonTapped() {
        let listViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        listViewController.personResults = DBManager.loadSavedPersons()
        listViewController.showingSaved = true
        navigationController?.pushViewController(listViewController, animated: true)
    }
    
    func setupNavigationController() {
        if showingSaved {
            title = "Сохраненные"
            
            let deleteAllButton = UIBarButtonItem(title: "Удалить все", style: .plain, target: self, action: #selector(deleteAllButtonTapped))
            deleteAllButton.tintColor = UIColor.red
            navigationItem.rightBarButtonItem = deleteAllButton
            
            tableView.tableHeaderView = nil
        } else {
            title = "Поиск"
            
            let savedButton = UIBarButtonItem(title: "Сохраненные", style: .plain, target: self, action: #selector(savedButtonTapped))
            navigationItem.rightBarButtonItem = savedButton
            
            searchBar.placeholder = "Имя персонажа"
            searchBar.delegate = self
        }
    }
    
    func setupTableView() {
        if showingSaved {
            personNotificationToken = personResults.observe({ (changes) in
                switch changes {
                case .error(let error):
                    self.showAlertError(error: error, desc: "Не удалось обновить список персонажей", critical: false)
                    self.personNotificationToken?.invalidate()
                default:
                    self.tableView.reloadData()
                }
            })
        }
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "PersonTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonTableViewCell")
    }
    
    func setupTableViewPlaceholder(text: String?) {
        if let text = text {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
            label.textColor = UIColor.black.withAlphaComponent(0.5)
            label.text = text
            label.numberOfLines = 0
            label.textAlignment = .center
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
    }
    
}

extension ListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showingSaved {
            if personResults.count == 0 {
                setupTableViewPlaceholder(text: "Вы пока что не сохранили ни одного персонажа")
            } else {
                setupTableViewPlaceholder(text: nil)
            }
            
            return personResults.count
        } else {
            if persons.count == 0 {
                setupTableViewPlaceholder(text: "Введите поисковый запрос для отображения результатов")
            } else {
                setupTableViewPlaceholder(text: nil)
            }
            
            return persons.count
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell") as! PersonTableViewCell
        var person: Person {
            if showingSaved {
                return personResults[indexPath.row]
            } else {
                return persons[indexPath.row]
            }
        }
        
        cell.nameLabel.text = person.name ?? "Неизвестно"
        cell.filmsCounterView.counterLabel.text = "\(person.filmsList.count)"
        cell.speciesCounterView.counterLabel.text = "\(person.speciesList.count)"
        cell.vehiclesCounterView.counterLabel.text = "\(person.vehiclesList.count)"
        cell.starshipsCounterView.counterLabel.text = "\(person.starshipsList.count)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        var person: Person {
            if showingSaved {
                return personResults[indexPath.row]
            } else {
                return persons[indexPath.row]
            }
        }
        
        let personDetailsViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "PersonDetailsViewController") as! PersonDetailsViewController
        personDetailsViewController.person = person
        navigationController?.pushViewController(personDetailsViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !showingSaved, indexPath.row == persons.count - 1, let nextPageUrl = pages[1] {
            let indicator = UIActivityIndicatorView()
            indicator.style = .gray
            indicator.startAnimating()
            tableView.tableFooterView = indicator
            
            APIManager.searchPeople(name: searchBar.text, customUrl: nextPageUrl) { [weak self](persons, pages, error) in
                self?.tableView.tableFooterView = UIView()
                if let persons = persons {
                    self?.persons.append(contentsOf: persons)
                    self?.pages = pages ?? [nil, nil]
                    DBManager.savePersons(persons)
                    self?.tableView.reloadData()
                } else {
                    self?.showAlertError(error: error, desc: "Не удалось загрузить список персонажей", critical: false)
                }
            }
        }
    }
    
}

extension ListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        APIManager.searchPeople(name: searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)) { [weak self] (persons, pages, error) in
            if let persons = persons {
                self?.persons = persons
                self?.pages = pages ?? [nil, nil]
                DBManager.savePersons(persons)
                self?.tableView.reloadData()
            } else {
                self?.showAlertError(error: error, desc: "Не удалось загрузить список персонажей", critical: false)
            }
        }
    }
    
}
