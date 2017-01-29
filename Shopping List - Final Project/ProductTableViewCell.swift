//
//  ProductTableViewCell.swift
//  Shopping List - Final Project
//
//  Created by admin on 14/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productQuantityLabel: UILabel!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productCompanyLabel: UILabel!
    
    @IBOutlet weak var productImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // SET background image to each cell
        //self.backgroundView = UIImageView(image: #imageLiteral(resourceName: "greyBackgroundImage"))
        

        // IF the user did not put an image - put the default one
        //if self.productImageView.image == nil{
            //self.productImageView.image = //
        //}
        
        // Change the picture to a circle one
        self.productImageView.layer.cornerRadius = self.productImageView.frame.size.width / 2
        self.productImageView.clipsToBounds = true

        // Configure the view for the selected state
        
    }

}
