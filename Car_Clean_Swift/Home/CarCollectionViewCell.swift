//
//  CarCollectionViewCell.swift
//  Car_Clean_Swift
//
//  Created by Alvaro Vinicius do Nascimento Fernandes on 16/12/19.
//  Copyright © 2019 Alvaro Vinicius do Nascimento Fernandes. All rights reserved.
//

import UIKit
import SDWebImage

class CarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    
    func configure(_ car: Home.CarModels.Carro?) {
        let url = URL(string: car?.url_foto ?? "")!
        img.sd_setImage(with: url, completed: nil)
        lbl.text = car?.nome
    }
}
