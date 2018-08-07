//
//  CreateNewViewController.swift
//  Shopper Shopper
//
//  Created by James Boric on 9/11/2015.
//  Copyright © 2015 Ode To Code. All rights reserved.
//

import UIKit
import CoreData

class CreateNewViewController: UIViewController {
    
    @IBOutlet weak var fadeView: UIView!
    
    @IBOutlet weak var listNameTextField: UITextField!
    
    @IBOutlet weak var shoppingDatePicker: UIDatePicker!
    
    var newList: NSManagedObject?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    @IBAction func cancelKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    let monthConversion = [1 : "January", 2 : "February", 3 : "March", 4 : "April", 5 : "May", 6 : "June", 7 : "July", 8 : "August", 9 : "September", 10 : "October", 11 : "November", 12: "December"]
    
    @IBAction func publishNewList(_ sender: UIButton) {
        
        let shoppingTripDate = shoppingDatePicker.date
        
        var listName : String?
        
        if listNameTextField.text != "" {
            
            listName = listNameTextField.text!
        }
        else {
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components([.year, .month, .day], from: shoppingTripDate)
            
            let year =  components.year
            let month = components.month
            let day = components.day
            
            listName = "\(day) - \(monthConversion[month!]!) - \(year)"
        }
        
        
        let context = self.context
        
        /*let ent = NSEntityDescription.entityForName("List", inManagedObjectContext: context)
        let newList = List(entity: ent!, insertIntoManagedObjectContext: context)*/
        let newList = NSEntityDescription.insertNewObject(forEntityName: "List", into: context)
        newList.setValue(listName, forKey: "name")
        newList.setValue(shoppingTripDate, forKey: "ShoppingDate")
        
        
        newList.setValue([], forKey: "items")
        newList.setValue([], forKey: "fetchedItems")
        
        do {
            try context.save()
        }
        
        catch {
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Error!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        }
        
        
        view.superview?.backgroundColor = UIColor.white
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: ({
            
            self.view.frame = CGRect(x: 0, y: -self.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height)
            //self.view.alpha = 0
            
        }),completion: { (Bool) in
            
            self.performSegue(withIdentifier: "the", sender: self)
            
            //self.presentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("thing") as! UINavigationController, animated: false, completion: nil)
            
        })

    }
    
    
    @IBAction func cancelCreateNew(_ sender: UIBarButtonItem) {
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: ({
            
            self.view.alpha = 0
            
        }),completion: { (Bool) in
            
            self.performSegue(withIdentifier: "the", sender: self)
            
        })
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor(red: 255 / 255, green: 214 / 255, blue: 0 / 255, alpha: 1)
    
        
    
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: ({
            self.fadeView.alpha = 0
        }),completion: { (Bool) in
        })
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    */

}
