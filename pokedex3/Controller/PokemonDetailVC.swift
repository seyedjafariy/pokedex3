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
    
    @IBOutlet weak var nameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = poke.name
        
    }


}
