//
//  AddNewCodeViewController.swift
//  Shopper Shopper
//
//  Created by James Boric on 19/04/2016.
//  Copyright © 2016 Ode To Code. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class AddNewCodeViewController: UIViewController {

    @IBOutlet weak var codeTextField: UITextField!
    
    @IBOutlet weak var storeTextField: UITextField!
    
    @IBOutlet weak var discountTextField: UITextField!
    
    @IBOutlet weak var expDatePicker: UIDatePicker!
    
    @IBOutlet weak var cardModel: UIView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardModel.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func moveKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        let code = codeTextField.text!
        let discount = discountTextField.text!
        let storeName = storeTextField.text!
        let expDate = expDatePicker.date
        
        
        let context = self.context
        
        let newCard = NSEntityDescription.insertNewObject(forEntityName: "Card", into: context)
        newCard.setValue(nil, forKey: "barcode")
        newCard.setValue(code, forKey: "code")
        newCard.setValue(discount, forKey: "discount")
        newCard.setValue(expDate, forKey: "expiryDate")
        newCard.setValue(storeName, forKey: "store")
        
        do {
            try context.save()
        }
            
        catch {
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Error!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        }
        
        performSegue(withIdentifier: "backFromCode", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromCode" {
            let thing = segue.destination as! UITabBarController
            thing.selectedIndex = 1
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
