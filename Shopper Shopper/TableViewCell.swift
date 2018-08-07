//
//  TableViewCell.swift
//  Shopper Shopper
//
//  Created by James Boric on 13/12/2015.
//  Copyright © 2015 Ode To Code. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var itemField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        itemField.isUserInteractionEnabled = false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
        
            let translation = panGestureRecognizer.translation(in: superview!)
        
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
        }
       
        return false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
