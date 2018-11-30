//
//  APIManager.swift
//  StarWarsExplorer
//
//  Created by Максим Скрябин on 30/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import Foundation

import Alamofire

class APIManager {
    
    struct URLs {
        static let peopleSearch = "https://swapi.co/api/people/?search="
    }
    
    static let shared = APIManager()
    var request: DataRequest?
    
    class func searchPeople(name: String?, customUrl: String? = nil, result: @escaping ([Person]?, [String?]?, Error?) -> Void) {
        var urlString: String {
            if let customUrl = customUrl {
                return customUrl
            } else {
                return URLs.peopleSearch + (name ?? "")
            }
        }
        
        if let url = URL(string: urlString) {
            if let request = APIManager.shared.request {
                request.cancel()
            }
            
            APIManager.shared.request = Alamofire.request(url).responseData { (response) in
                if let data = response.data, data.count > 0 {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let personSearch = try decoder.decode(PersonSearch.self, from: data)
                        
                        let pagesArray: [String?] = [personSearch.previous, personSearch.next]
                        let personsArray: [Person] = personSearch.results
                        result(personsArray, pagesArray, nil)
                    } catch let error {
                        // Ошибка при парсе json'a
                        result(nil, nil, error)
                    }
                } else {
                    // Ошибка выполнении запроса
                    result(nil, nil, response.error)
                }
            }
        } else {
            // Некорректный url
            result(nil, nil, nil)
        }
    }
    
}
