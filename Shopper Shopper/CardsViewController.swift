//
//  CardsViewController.swift
//  Shopper Shopper
//
//  Created by James Boric on 19/04/2016.
//  Copyright © 2016 Ode To Code. All rights reserved.
//

import UIKit
import CoreData

class CardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var addNewContainer: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButtonImage: UIImageView!
    
    @IBOutlet weak var expandView: UIView!
    
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet var voucherButtons: [UIView]!
    
    @IBOutlet weak var noneLabel: UILabel!
    
    var originalAddFrame: CGRect!
    
    
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    var fetchController: NSFetchedResultsController = NSFetchedResultsController()
    
    func generateFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
        
        let sortDescriptor = NSSortDescriptor(key: "store", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    func fetch() -> NSFetchedResultsController<NSFetchRequestResult> {
        
        fetchController = NSFetchedResultsController(fetchRequest: generateFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchController
    }
    
    var cardObjects: [NSManagedObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cardObjects = []
        fetchController = fetch()
        
        fetchController.delegate = self
        
        do {
            try fetchController.performFetch()
        }
        catch {
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Error!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        }
        for i in 0..<fetchController.sections![0].numberOfObjects {
            let contextObject = fetchController.object(at: IndexPath(item: i, section: 0)) as! NSManagedObject
            
            cardObjects.append(contextObject)
        }
        
        if cardObjects.count == 0 {
            noneLabel.alpha = 1
        }
        
        for n in voucherButtons {
            n.alpha = 0
            n.frame.origin.y = 66
        }
    
        
        tableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 25 / 256, green: 174 / 256, blue: 255 / 256, alpha: 1)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        if shouldMoveToQR {
            performSegue(withIdentifier: "moveToQRMake", sender: nil)
            shouldMoveToQR = false
        }
        
        else if shouldMoveToBarcode {
            performSegue(withIdentifier: "moveToBarcodeCreate", sender: nil)
            shouldMoveToBarcode = false
        }
        
        else if shouldMoveToCode {
            performSegue(withIdentifier: "moveToCodeCreate", sender: nil)
            shouldMoveToCode = false
        }
        
        tableView.separatorStyle = .none
        
        addNewContainer.clipsToBounds = true
        
        expandView.layer.cornerRadius = 35
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 230 / 255, green: 81 / 255, blue: 0 / 255, alpha: 1)
        
        plusButton.layer.cornerRadius = 35
        
        originalAddFrame = CGRect(x: view.frame.size.width - 78, y: 8, width: 70, height: 70)
        
        expandView.frame = originalAddFrame
        
        
        
    }
    var originalOrigin: CGFloat = 0
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        originalOrigin = voucherButtons[0].frame.origin.y
        
        
        
        
        for i in voucherButtons {
            i.frame.origin.y = 66
            i.alpha = 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !shouldMoveToQR {
            expandView.frame = originalAddFrame
        
            addButtonImage.transform = CGAffineTransform(rotationAngle: 0)
            shouldExpand = true
            
            for i in voucherButtons {
                i.alpha = 1
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    var shouldExpand = true
    
    @IBAction func createNewCardPressed(_ sender: UIButton) {
       
        if shouldExpand {
            
            expandView.alpha = 1
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                
                self.expandView.frame = CGRect(x: -10, y: -100, width: self.view.frame.size.width + 100, height: self.view.frame.size.width + 100)
                
                self.addButtonImage.transform = CGAffineTransform(rotationAngle: -CGFloat(M_PI) / 4)
                
                
                }, completion: {(Bool) in
                    
            })
            
            for i in 0..<self.voucherButtons.count {
                UIView.animate(withDuration: 0.3, delay: Double(i) * 0.05 + 0.1, options: UIViewAnimationOptions.curveLinear, animations: {
                    self.voucherButtons[i].frame.origin.y = 16
                    self.voucherButtons[i].alpha = 1
                    }, completion: nil)
            }

            let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
            cornerRadiusAnimation.fromValue = plusButton.layer.cornerRadius
            cornerRadiusAnimation.toValue = (view.frame.size.width + 100) / 2
            cornerRadiusAnimation.duration = 0.3
            cornerRadiusAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            expandView.layer.add(cornerRadiusAnimation, forKey: "cornerRadius")
            shouldExpand = false
        }
        else {
            expandView.alpha = 1
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                
                self.expandView.frame = self.originalAddFrame
                
                self.addButtonImage.transform = CGAffineTransform(rotationAngle: 0)
                
                
                }, completion: {(Bool) in
                    
            })
            
            for (var i = 2; i >= 0; i -= 1) {
                UIView.animate(withDuration: 0.3, delay: Double(2 - i) * 0.05, options: UIViewAnimationOptions.curveLinear, animations: {
                    self.voucherButtons[i].frame.origin.y = 66
                    self.voucherButtons[i].alpha = 0
                    }, completion: nil)
            }
            
            let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
            cornerRadiusAnimation.fromValue = plusButton.layer.cornerRadius
            cornerRadiusAnimation.toValue = 35
            cornerRadiusAnimation.duration = 0.3
            cornerRadiusAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            expandView.layer.add(cornerRadiusAnimation, forKey: "cornerRadius")
            
            shouldExpand = true
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cardObjects.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCellIdentifier", for: indexPath) as! CardTableViewCell
        //If it's a bitmap
        let currentObject = cardObjects[indexPath.row]
        cell.card.tag = indexPath.row
        //Expires in X days
        let date = currentObject.value(forKey: "expiryDate") as! Date
        //let numOfHoursLeft = NSCalendar.currentCalendar().components(.Hour, fromDate: NSDate(), toDate: date, options: []).hour
        
        
        
        let timeDifference = date.timeIntervalSince(Date())
        
        let numOfDaysLeft = Int(round(timeDifference / 60 / 60 / 24))
        //If it's a bitmap
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        cell.storeLabel.text = currentObject.value(forKey: "store") as? String
        cell.discountLabel.text = currentObject.value(forKey: "discount") as? String
        
        if numOfDaysLeft >= 0 {
            if numOfDaysLeft == 0 {
                cell.expiryLabel.text = "Expires today"
            }
            else if numOfDaysLeft == 1 {
                cell.expiryLabel.text = "Expires tomorrow"
            }
            else {
                cell.expiryLabel.text = "Expires in \(numOfDaysLeft) days"
            }
        }
        else {
            if numOfDaysLeft == -1 {
                cell.expiryLabel.text = "Expired yesterday"
            }
            else {
                cell.expiryLabel.text = "Expired \(-numOfDaysLeft) days ago"
            }
        }
        if currentObject.value(forKey: "code") == nil {
            cell.graphicImage.image = currentObject.value(forKey: "barcode") as? UIImage
        }
            //if it's a code
        else {
             cell.codeLabel.text = currentObject.value(forKey: "code") as? String
            cell.graphicImage.alpha = 0
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width / 1.585772508
    }
    
    let bigView = UIImageView()
    let bigButton = UIButton()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if cardObjects[indexPath.row].value(forKey: "code") == nil {
            bigView.frame = CGRect(
                
                x: 0,
                
                y: 63,
                
                width: view.frame.size.width,
                
                height: view.frame.size.height - 111
            )
            
            
            bigView.backgroundColor = UIColor.black
            bigView.contentMode = .scaleAspectFit
            bigView.image = UIImage(cgImage: (cardObjects[indexPath.row].value(forKey: "barcode") as! UIImage).cgImage!, scale: 1.0, orientation: .right)
            
            
            bigButton.frame = view.frame
            bigButton.addTarget(self, action: #selector(CardsViewController.mini), for: .touchUpInside)
            //bigButton.backgroundColor = UIColor.redColor()
            
            view.addSubview(bigView)
            
            view.addSubview(bigButton)
        }
        
        
    }
    
    func mini() {
        bigView.removeFromSuperview()
        bigButton.removeFromSuperview()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
    // Delete the row from the data source
        
        
        
        context.delete(cardObjects[indexPath.row])
        cardObjects.remove(at: indexPath.row)
        
        do {
            try context.save()
        }
            
        catch {
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Error!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        }

        if cardObjects.count == 0 {
            UIView.animate(withDuration: 0.45, animations: {
                self.noneLabel.alpha = 1
            })
            
        }
        
        //tableView.reloadData()
        tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}
