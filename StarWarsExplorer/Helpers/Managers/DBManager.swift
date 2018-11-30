//
//  DBManager.swift
//  StarWarsExplorer
//
//  Created by Максим Скрябин on 30/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import Foundation

import RealmSwift

class DBManager {
    
    class func loadSavedPersons() -> Results<Person> {
        let realm = try! Realm()
        return realm.objects(Person.self)
    }
    
    class func savePerson(_ person: Person?) {
        if let person = person {
            let realm = try! Realm()
            try! realm.write {
                realm.add(person, update: true)
            }
        }
    }
    
    class func savePersons(_ persons: [Person]?) {
        if let persons = persons, persons.count != 0 {
            let realm = try! Realm()
            try! realm.write {
                realm.add(persons, update: true)
            }
        }
    }
    
    class func deletePerson(_ person: Person?) {
        let realm = try! Realm()
        if let person = person, let personObject = realm.object(ofType: Person.self, forPrimaryKey: person.name) {
            try! realm.write {
                realm.delete(personObject)
            }
        }
    }
    
    class func deletePersons(_ persons: [Person]?) {
        if let persons = persons, persons.count != 0 {
            let realm = try! Realm()
            var personsToDelete: [Object] = []
            for person in persons {
                if let personObject = realm.object(ofType: Person.self, forPrimaryKey: person.name) {
                    personsToDelete.append(personObject)
                }
            }
            
            try! realm.write {
                realm.delete(personsToDelete)
            }
        }
    }
    
}
