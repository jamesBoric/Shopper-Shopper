//
//  CardTableViewCell.swift
//  Shopper Shopper
//
//  Created by James Boric on 19/04/2016.
//  Copyright © 2016 Ode To Code. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var discountLabel: UILabel!
    
    @IBOutlet weak var storeLabel: UILabel!
    
    @IBOutlet weak var graphicImage: UIImageView!
   
    @IBOutlet weak var codeLabel: UILabel!
    
    @IBOutlet weak var expiryLabel: UILabel!
    
    override func awakeFromNib() {
    
        super.awakeFromNib()
        
        card.layer.cornerRadius = 15
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        super.setSelected(selected, animated: animated)

    }

}
