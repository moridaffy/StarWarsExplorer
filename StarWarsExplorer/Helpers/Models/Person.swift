//
//  Person.swift
//  StarWarsExplorer
//
//  Created by Максим Скрябин on 30/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import Foundation

import RealmSwift

struct PersonSearch: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Person]
}

class Person: Object, Decodable, Encodable {
    
    @objc dynamic var name: String?
    @objc dynamic var height: String?
    @objc dynamic var mass: String?
    @objc dynamic var hairColor: String?
    @objc dynamic var skinColor: String?
    @objc dynamic var eyeColor: String?
    @objc dynamic var birthYear: String?
    @objc dynamic var gender: String?
    
    var filmsList = List<String>()
    var speciesList = List<String>()
    var vehiclesList = List<String>()
    var starshipsList = List<String>()
    
    var genderType: GenderType {
        return GenderType(rawValue: gender ?? "") ?? .Unknown
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.height = try container.decode(String.self, forKey: .height)
        self.mass = try container.decode(String.self, forKey: .mass)
        self.hairColor = try container.decode(String.self, forKey: .hairColor)
        self.skinColor = try container.decode(String.self, forKey: .skinColor)
        self.eyeColor = try container.decode(String.self, forKey: .eyeColor)
        self.birthYear = try container.decode(String.self, forKey: .birthYear)
        self.gender = try container.decode(String.self, forKey: .gender)
        
        let films = try container.decode([String].self, forKey: .filmsList)
        self.filmsList.append(objectsIn: films)
        let species = try container.decode([String].self, forKey: .speciesList)
        self.speciesList.append(objectsIn: species)
        let vehicles = try container.decode([String].self, forKey: .vehiclesList)
        self.vehiclesList.append(objectsIn: vehicles)
        let starships = try container.decode([String].self, forKey: .starshipsList)
        self.starshipsList.append(objectsIn: starships)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.height, forKey: .height)
        try container.encode(self.mass, forKey: .mass)
        try container.encode(self.hairColor, forKey: .hairColor)
        try container.encode(self.skinColor, forKey: .skinColor)
        try container.encode(self.eyeColor, forKey: .eyeColor)
        try container.encode(self.birthYear, forKey: .birthYear)
        try container.encode(self.gender, forKey: .gender)
        
        try container.encode(Array(self.filmsList), forKey: .filmsList)
        try container.encode(Array(self.speciesList), forKey: .speciesList)
        try container.encode(Array(self.vehiclesList), forKey: .vehiclesList)
        try container.encode(Array(self.starshipsList), forKey: .starshipsList)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case height
        case mass
        case hairColor
        case skinColor
        case eyeColor
        case birthYear
        case gender

        case filmsList = "films"
        case speciesList = "species"
        case vehiclesList = "vehicles"
        case starshipsList = "starships"
        
    }
    
    override class func primaryKey() -> String? {
        return "name"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["category"]
    }
    
    func createInformationArrays() -> ([String], [String]) {
        var titleArray: [String] = []
        var contentArray: [String] = []
        
        if let height = height {
            titleArray.append("Рост")
            contentArray.append(height)
        }
        
        if let mass = mass {
            titleArray.append("Вес")
            contentArray.append(mass)
        }
        
        if let hairColor = hairColor {
            titleArray.append("Цвет волос")
            contentArray.append(hairColor.capitalized)
        }
        
        if let skinColor = skinColor {
            titleArray.append("Цвет кожи")
            contentArray.append(skinColor.capitalized)
        }
        
        if let eyeColor = eyeColor {
            titleArray.append("Цвет глаз")
            contentArray.append(eyeColor.capitalized)
        }
        
        if let birthYear = birthYear {
            titleArray.append("Год рождения")
            contentArray.append(birthYear)
        }
        
        titleArray.append("Пол")
        contentArray.append(genderType.localizedName)
        
        return (titleArray, contentArray)
    }
    
}

extension Person {
    
    enum GenderType: String {
        case Male = "male"
        case Female = "female"
        case Unknown
        
        var localizedName: String {
            switch self {
            case .Male:
                return "Мужчина"
            case .Female:
                return "Женщина"
            case .Unknown:
                return "Неизвестно"
            }
        }
    }
    
}
