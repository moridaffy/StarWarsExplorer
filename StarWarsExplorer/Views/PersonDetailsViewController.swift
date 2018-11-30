//
//  PersonDetailsViewController.swift
//  StarWarsExplorer
//
//  Created by Максим Скрябин on 30/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import UIKit

class PersonDetailsViewController: UITableViewController {
    
    var person: Person!
    
    var titleArray: [String] = []
    var contentArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
    }
    
    @objc func deleteButtonTapped() {
        let yes = UIAlertAction(title: "Да, удалить", style: .destructive, handler: { _ in
            DBManager.deletePerson(self.person)
            self.navigationController?.popViewController(animated: true)
        })
        showAlert(title: "Удалить?", body: "Вы уверены, что хотите удалить персонажа \"\(person.name ?? "")\"?", button: "Нет, отменить", actions: [yes])
    }
    
    func setupNavigationBar() {
        title = person.name ?? "Информация"
        
        let deleteButton = UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: #selector(deleteButtonTapped))
        deleteButton.tintColor = UIColor.red
        navigationItem.rightBarButtonItem = deleteButton
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "PersonTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonTableViewCell")
        tableView.register(UINib(nibName: "PersonInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonInfoTableViewCell")
        tableView.tableFooterView = UIView()
        
        let (t, c) = person.createInformationArrays()
        titleArray = t
        contentArray = c
    }
    
}

extension PersonDetailsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count + 1
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 87.0
        } else {
            return 61.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 87.0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell") as! PersonTableViewCell
            
            cell.nameLabel.text = person.name ?? "Неизвестно"
            cell.filmsCounterView.counterLabel.text = "\(person.filmsList.count)"
            cell.speciesCounterView.counterLabel.text = "\(person.speciesList.count)"
            cell.vehiclesCounterView.counterLabel.text = "\(person.vehiclesList.count)"
            cell.starshipsCounterView.counterLabel.text = "\(person.starshipsList.count)"
            
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonInfoTableViewCell") as! PersonInfoTableViewCell
            
            cell.titleLabel.text = titleArray[indexPath.row - 1]
            cell.contentLabel.text = contentArray[indexPath.row - 1]
            
            cell.selectionStyle = .none
            return cell
        }
    }
}
