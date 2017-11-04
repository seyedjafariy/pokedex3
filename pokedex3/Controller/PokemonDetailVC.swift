//
//  PokemonDetailVCViewController.swift
//  pokedex3
//
//  Created by ITParsa on 11/3/17.
//  Copyright © 2017 ITParsa. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var poke : Pokemon!
    
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = poke.name.capitalized
        
        let img = UIImage(named: "\(poke.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        pokedexLbl.text = "\(poke.pokedexId)"
        
        
        downloadDetails()
    }
    
    func downloadDetails(){
        poke.downloadPokemonDetails{
            print("details done latest")
            self.updateUI()
        }
        poke.downloadCharacteristics {
            print("character done latest")
            self.updateUI()
        }
        poke.getEvolutions {
            self.updateNextEvoDetails()
            
        }
    }
    
    func updateNextEvoDetails(){
        
        descriptionLbl.text = poke.description
        if poke.nextEvolutionId == ""{
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        }else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: poke.nextEvolutionId)
            let str = "Next Evolution: \(poke.nextEvolutionName) - LVL \(poke.nextEvolutionLevel)"
            evoLbl.text = str
        }
    }
    
    func updateUI(){
        attackLbl.text = "\(poke.attack)"
        defenseLbl.text = "\(poke.defense)"
        heightLbl.text = "\(poke.height)"
        weightLbl.text = "\(poke.weight)"
        typeLbl.text = poke.type
        descriptionLbl.text = poke.description
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)  
    }
    

}
