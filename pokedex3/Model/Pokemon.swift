//
//  Pokemon.swift
//  pokedex3
//
//  Created by ITParsa on 11/2/17.
//  Copyright © 2017 ITParsa. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    private var _name: String!
    private var _pokedexId : Int!
    private var _description: String!
    private var _type: String!
    private var _defense: Int!
    private var _height: Int!
    private var _weight: Int!
    private var _attack: Int!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    private var _charactrasticURL : String!
    private var _evolutionsURL : String!
    private var otherDownloadFinished = false
    
    
    var height: Int {
        if _height == nil{
            _height = 0
        }
        return _height
    }
    
    var weight: Int {
        if _weight == nil{
            _weight = 0
        }
        return _weight
    }
    
    var attack: Int {
        if _attack == nil{
            _attack = 0
        }
        return _attack
    }
    
    var defense: Int {
        if _defense == nil{
            _defense = 0
        }
        return _defense
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil{
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil{
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil{
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil{
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var type: String {
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var description: String {
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
    var name : String{
        return _name
    }
    
    var pokedexId :Int {
        
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_POKEMON_BASE)\(pokedexId)"
        self._charactrasticURL = "\(URL_CHARACTRASTICS_BASE)\(pokedexId)"
        self._evolutionsURL = "\(URL_EVOLUTIONS_BASE)\(pokedexId)"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete){
        Alamofire.request(self._pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? Int{
                    self._weight = weight
                }
                
                if let height = dict["height"] as? Int{
                    self._height = height
                }
                
                if let stats = dict["stats"] as? [Dictionary<String, AnyObject>]{
                    if let attackBase_stat = stats[4]["base_stat"] as? Int{
                        self._attack = attackBase_stat
                    }
                    if let defenseBase_stat = stats[3]["base_stat"] as? Int{
                        self._defense = defenseBase_stat
                    }
                }
                if let types = dict["types"] as? [Dictionary<String, AnyObject>]{
                    for type in types{
                        if let param = type["type"] as? Dictionary<String, String>{
                            if let name = param["name"]{
                                if self._type != nil && self._type.count > 1{
                                    self._type.append("/")
                                    self._type.append(name.capitalized)
                                }else{
                                    self._type = name.capitalized
                                }
                            }
                        }
                    }
                }
                
                
                print("stats recieved ")
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                print(self._type)
                
            }
            if self.otherDownloadFinished{
                completed()
            }else {
                self.otherDownloadFinished = true
            }
            
        }
    }
    
    func downloadCharacteristics(completed: @escaping DownloadComplete){
        Alamofire.request(self._charactrasticURL).responseJSON(completionHandler: {(response) in
            if let dict = response.result.value as? Dictionary<String, AnyObject>{
                if let descriptions = dict["descriptions"] as? [Dictionary<String, AnyObject>]{
                    for x in 0..<descriptions.count{
                        if let language = descriptions[x]["language"] as? Dictionary<String, String>{
                            if language["name"] == "en"{
                                if let desc = descriptions[x]["description"] as? String{
                                    self._description = desc
                                    break
                                }
                            }
                        }
                    }
                }
                
                if self.otherDownloadFinished{
                    completed()
                }else{
                    self.otherDownloadFinished = true
                }
            }
        })
    }
    
    func getEvolutions(completed: @escaping DownloadComplete){
        Alamofire.request(self._evolutionsURL).responseJSON(completionHandler: { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject>{
                
                if let chain = dict["chain"] as? Dictionary<String, AnyObject>{
                    
                    if let evolves = chain["evolves_to"] as? [Dictionary<String, AnyObject>], evolves.count > 0{
                        
                        if let species = evolves[0]["species"] as? Dictionary<String, String> {
                            print(species)
                            self._nextEvolutionName = species["name"]?.capitalized
                            let tempNextURL = species["url"]
                            let subStr = (tempNextURL?.split(separator: "/"))!
                            let nextEvoId = subStr[(subStr.count)-1]
                            self._nextEvolutionId = "\(nextEvoId)"
                        }
                        
                        if let details = evolves[0]["evolution_details"] as? [Dictionary<String, AnyObject>], details.count > 0  {
                            if let tempLvl = details[0]["min_level"] as? Int{
                                self._nextEvolutionLevel = "\(tempLvl)"
                            }else {
                                self._nextEvolutionLevel = ""
                            }
                        }
                    }
                }
                print("evo details")
                print(self._nextEvolutionLevel)
                print(self._nextEvolutionId)
                print(self._nextEvolutionName)
            }
            completed()
        })
        
    }
    
}



















