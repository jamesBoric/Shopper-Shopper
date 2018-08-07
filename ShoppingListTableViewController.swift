//
//  ShoppingListTableViewController.swift
//  Shopper Shopper
//
//  Created by James Boric on 9/11/2015.
//  Copyright © 2015 Ode To Code. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    var shoppingListObject : NSManagedObject?
    
    var objectIndexPath : IndexPath?
    
    var items: [String]!
    var fetchedItems: [String]!
    
    let tickView = UIView()
    
    var currentIndexPath = IndexPath(item: 0, section: 0)
    
    let tickHeight: CGFloat = 60
    
    let crossView = UIView()
    
    let crossRightCircleLayer = CAShapeLayer()
    let crossLeftCircleLayer = CAShapeLayer()
    let crossCircleLayer = CAShapeLayer()
    let crossLayer = CAShapeLayer()
    var whiteCrossLayer = CAShapeLayer()
    
    let rightCircleLayer = CAShapeLayer()
    let leftCircleLayer = CAShapeLayer()
    let tickCircleLayer = CAShapeLayer()
    let tickLayer = CAShapeLayer()
    var whiteTickLayer = CAShapeLayer()
    
    
    
    var fetchController: NSFetchedResultsController = NSFetchedResultsController()
    
    let plusButton = UIButton()
    
    func generateFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        
        let sortDescriptor = NSSortDescriptor(key: "shoppingDate", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    func fetch() -> NSFetchedResultsController<NSFetchRequestResult> {
        fetchController = NSFetchedResultsController(fetchRequest: generateFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchController
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchController = fetch()
        fetchController.delegate = self
        
        do {
            try fetchController.performFetch()
        }
        catch {
            print("ERROR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        }
        
        
        items = shoppingListObject!.value(forKey: "items") as! [String]
        
        fetchedItems = shoppingListObject!.value(forKey: "fetchedItems") as! [String]
        
        
        navBar.title = shoppingListObject!.value(forKey: "name") as? String
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(ShoppingListTableViewController.appMovedToBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        
        
        tickView.frame = CGRect(x: view.frame.size.width - (tickHeight / 2), y: (tableView.rowHeight - tickHeight) / 2, width: tickHeight, height: tickHeight)
        tickView.layer.zPosition = -1
        
        let completedCircle1 = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: tickHeight, height: tickHeight))
        let completedCircle2 = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: tickHeight, height: tickHeight))
        let lineWidth: CGFloat = 5
        let myGreen = UIColor(red: 76 / 255, green: 220 / 255, blue: 80 / 255, alpha: 1).cgColor
        
        rightCircleLayer.path = completedCircle1.cgPath
        rightCircleLayer.strokeColor = myGreen
        rightCircleLayer.fillColor = UIColor.clear.cgColor
        rightCircleLayer.lineWidth = lineWidth
        rightCircleLayer.strokeEnd = 0
        rightCircleLayer.lineCap = kCALineCapRound
        rightCircleLayer.actions = ["strokeEnd" : NSNull()]
        tickView.transform = CGAffineTransform(rotationAngle: 270 * CGFloat(M_PI) / CGFloat(180.0))
        
        leftCircleLayer.path = completedCircle2.cgPath
        leftCircleLayer.strokeColor = myGreen
        leftCircleLayer.fillColor = UIColor.clear.cgColor
        leftCircleLayer.lineWidth = lineWidth
        leftCircleLayer.strokeStart = 0.5
        leftCircleLayer.lineCap = kCALineCapRound
        leftCircleLayer.actions = ["strokeEnd" : NSNull()]
        
        let tickCircleContainer = UIBezierPath(ovalIn: CGRect(x: (lineWidth + 4) / 2, y: (lineWidth + 4) / 2, width: tickHeight - (lineWidth + 4), height: tickHeight - (lineWidth + 4)))
        
        tickCircleLayer.path = tickCircleContainer.cgPath
        tickCircleLayer.fillColor = myGreen
        tickCircleLayer.opacity = 0
        tickCircleLayer.actions = ["opacity" : NSNull()]
        
        let tickPath = UIBezierPath()
        tickPath.move(to: CGPoint(x: 27.23, y: 12.5))
        tickPath.addLine(to: CGPoint(x: 16.5, y: 24.33))
        tickPath.addLine(to: CGPoint(x: 39.5, y: 46.5))
        
        
        tickLayer.path = tickPath.cgPath
        tickLayer.strokeColor = myGreen
        tickLayer.fillColor = UIColor.clear.cgColor
        tickLayer.lineWidth = 4
        tickLayer.lineCap = kCALineCapRound
        
        whiteTickLayer.path = tickPath.cgPath
        whiteTickLayer.strokeColor = UIColor.white.cgColor
        whiteTickLayer.fillColor = UIColor.clear.cgColor
        whiteTickLayer.lineWidth = 4
        whiteTickLayer.lineCap = kCALineCapRound
        whiteTickLayer.actions = ["opacity": NSNull()]
        
        tickView.layer.addSublayer(tickCircleLayer)
        tickView.layer.addSublayer(rightCircleLayer)
        tickView.layer.addSublayer(leftCircleLayer)
        
        
        tickView.layer.addSublayer(tickLayer)
        tickView.layer.addSublayer(whiteTickLayer)
        whiteTickLayer.opacity = 0
        
        
        crossView.frame = CGRect(x: view.frame.size.width - (tickHeight / 2), y: (tableView.rowHeight - tickHeight) / 2, width: tickHeight, height: tickHeight)
        
        let crossCompletedCircle1 = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: tickHeight, height: tickHeight))
        let crossCompletedCircle2 = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: tickHeight, height: tickHeight))
        let myRed = UIColor(red: 255 / 255, green: 37 / 255, blue: 44 / 255, alpha: 1).cgColor
        
        crossRightCircleLayer.path = crossCompletedCircle1.cgPath
        crossRightCircleLayer.strokeColor = myRed
        crossRightCircleLayer.fillColor = UIColor.clear.cgColor
        crossRightCircleLayer.lineWidth = lineWidth
        crossRightCircleLayer.strokeEnd = 0
        crossRightCircleLayer.lineCap = kCALineCapRound
        crossRightCircleLayer.actions = ["strokeEnd" : NSNull()]
        
        crossLeftCircleLayer.path = crossCompletedCircle2.cgPath
        crossLeftCircleLayer.strokeColor = myRed
        crossLeftCircleLayer.fillColor = UIColor.clear.cgColor
        crossLeftCircleLayer.lineWidth = lineWidth
        crossLeftCircleLayer.strokeStart = 0.5
        crossLeftCircleLayer.lineCap = kCALineCapRound
        crossLeftCircleLayer.actions = ["strokeEnd" : NSNull()]
        
        crossView.transform = CGAffineTransform(rotationAngle: 270 * CGFloat(M_PI) / CGFloat(180.0))
        crossView.layer.zPosition = -2
        
        let crossCircleContainer = UIBezierPath(ovalIn: CGRect(x: (lineWidth + 4) / 2, y: (lineWidth + 4) / 2, width: tickHeight - (lineWidth + 4), height: tickHeight - (lineWidth + 4)))
        
        crossCircleLayer.path = crossCircleContainer.cgPath
        crossCircleLayer.fillColor = myRed
        crossCircleLayer.opacity = 0
        crossCircleLayer.actions = ["opacity" : NSNull()]
        
        let crossPath = UIBezierPath()
        crossPath.move(to: CGPoint(x: 15, y: 15))
        crossPath.addLine(to: CGPoint(x: 45, y: 45))
        crossPath.addLine(to: CGPoint(x: 30.1, y: 30))
        crossPath.addLine(to: CGPoint(x: 45, y: 15))
        crossPath.addLine(to: CGPoint(x: 15, y: 45))
        crossPath.addLine(to: CGPoint(x: 15, y: 45))
        crossPath.addLine(to: CGPoint(x: 15, y: 45))
        
        crossLayer.path = crossPath.cgPath
        crossLayer.strokeColor = myRed
        crossLayer.fillColor = UIColor.clear.cgColor
        crossLayer.lineWidth = 4
        
        whiteCrossLayer.path = crossPath.cgPath
        whiteCrossLayer.strokeColor = UIColor.white.cgColor
        whiteCrossLayer.fillColor = UIColor.clear.cgColor
        whiteCrossLayer.lineWidth = 4
        whiteCrossLayer.opacity = 0
        whiteCrossLayer.actions = ["opacity": NSNull()]
        
        
        
        
        crossView.layer.addSublayer(crossCircleLayer)
        crossView.layer.addSublayer(crossRightCircleLayer)
        crossView.layer.addSublayer(crossLeftCircleLayer)
        crossView.layer.addSublayer(crossLayer)
        crossView.layer.addSublayer(whiteCrossLayer)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveToCoreData()
        //Save to core data tomorow
        //First deal with deletions + picked up
    }
    
    func appMovedToBackground() {
        saveToCoreData()
    }
    
    
    func saveToCoreData() {
        let object = fetchController.object(at: objectIndexPath!)
        object.setValue(items, forKey: "items")
        object.setValue(fetchedItems, forKey: "fetchedItems")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            
            return items.count + 1
        }
        return fetchedItems.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! TableViewCell
            
            cell.itemField.text! = ""
            if indexPath.row < items.count {
                
                cell.itemField.text = items[indexPath.row]
                
                let recognizer = UIPanGestureRecognizer(target: self, action: #selector(ShoppingListTableViewController.panDidActivate(_:)))
                recognizer.delegate = cell
                cell.addGestureRecognizer(recognizer)
            }
            
            
            cell.itemField.isUserInteractionEnabled = false
            
            return cell
        }
        else {
            let completedCell = tableView.dequeueReusableCell(withIdentifier: "fetchedItemsIdentifier", for: indexPath) as! FetchedTableViewCell
            completedCell.textLabel!.text = fetchedItems[indexPath.row]
            
            let reappendRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ShoppingListTableViewController.reappendItem(_:)))
            reappendRecognizer.delegate = completedCell
            completedCell.addGestureRecognizer(reappendRecognizer)
            
            return completedCell
        }
        
        
    }
    
    
    func reappendItem(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        
        let cell = sender.delegate as! UITableViewCell
        
        
        if sender.state == .changed {
            
            if translation.x < 0 {
                cell.frame.origin.x = translation.x * view.frame.size.width / (view.frame.size.width - cell.frame.origin.x)
                crossView.frame.origin.x = cell.frame.size.width + (-(cell.frame.origin.x) - tickHeight) / 2
                
                crossRightCircleLayer.strokeEnd = -cell.frame.origin.x / view.frame.size.width
                crossLeftCircleLayer.strokeEnd = crossRightCircleLayer.strokeEnd + 0.5
                crossCircleLayer.opacity = Float(-cell.frame.origin.x / view.frame.size.width) * 2
                whiteCrossLayer.opacity = crossCircleLayer.opacity
            }
            else {
                
                cell.frame.origin.x = 0
            }
        }
        else if sender.state == .began {
            
            cell.clipsToBounds = false
            cell.addSubview(crossView)
        }
        else if sender.state == .ended {
            if cell.frame.origin.x > -view.frame.size.width / 2 + 9 {
                
                let duration: TimeInterval = 0.2
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                    
                    cell.frame.origin.x = 0
                    self.crossView.frame.origin.x = self.view.frame.size.width - (self.tickHeight / 2)
                    }, completion: nil)
                
                let opacityAnimation = CABasicAnimation(keyPath: "opacity")
                
                opacityAnimation.toValue = 0
                opacityAnimation.duration = duration
                opacityAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                crossCircleLayer.add(opacityAnimation, forKey: opacityAnimation.keyPath)
                whiteCrossLayer.add(opacityAnimation, forKey: opacityAnimation.keyPath)
                
                let strokeEnd1Animation = CABasicAnimation(keyPath: "strokeEnd")
                strokeEnd1Animation.duration = duration
                strokeEnd1Animation.toValue = 0
                strokeEnd1Animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                crossRightCircleLayer.add(strokeEnd1Animation, forKey: strokeEnd1Animation.keyPath)
                
                let strokeEnd2Animation = CABasicAnimation(keyPath: "strokeEnd")
                strokeEnd2Animation.duration = duration
                strokeEnd2Animation.toValue = 0.5
                strokeEnd2Animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                crossLeftCircleLayer.add(strokeEnd2Animation, forKey: strokeEnd2Animation.keyPath)
                
                
            }
            else {
                reappendToList(tableView.indexPath(for: cell)!)
            }
            
        }
        
    }
    
    func reappendToList(_ indexPath: IndexPath) {
        didJustDelete = true
        self.navigationItem.rightBarButtonItem = nil
        let reserveIndexPath = currentIndexPath
        currentIndexPath = IndexPath(item: reserveIndexPath.row + 1, section: 0)
        let reappendedItem = fetchedItems[indexPath.row]
        fetchedItems.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        items.insert(reappendedItem, at: 0)
        tableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
        didJustDelete = false
    }
    
    
    var originalOrigin = CGPoint(x: 0, y: 0)
    
    func panDidActivate(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        
        let cell = sender.delegate as! UITableViewCell
        
        
        if sender.state == .changed {
            
            if translation.x < 0 {
                cell.frame.origin.x = translation.x * view.frame.size.width / (view.frame.size.width - cell.frame.origin.x)
                
                tickView.frame.origin.x = cell.frame.size.width + (-(cell.frame.origin.x) - tickHeight) / 2
                
                rightCircleLayer.strokeEnd = -cell.frame.origin.x / view.frame.size.width
                leftCircleLayer.strokeEnd = rightCircleLayer.strokeEnd + 0.5
                tickCircleLayer.opacity = Float(-cell.frame.origin.x / view.frame.size.width) * 2
                whiteTickLayer.opacity = tickCircleLayer.opacity
            }
            else {
                
                cell.frame.origin.x = 0
            }
        }
        else if sender.state == .began {
            
            cell.clipsToBounds = false
            cell.addSubview(tickView)
        }
        else if sender.state == .ended {
            if cell.frame.origin.x > -view.frame.size.width / 2 + 9 {
                
                let duration: TimeInterval = 0.2
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                    
                    cell.frame.origin.x = 0
                    self.tickView.frame.origin.x = self.view.frame.size.width - (self.tickHeight / 2)
                    }, completion: nil)
                
                let opacityAnimation = CABasicAnimation(keyPath: "opacity")
                
                opacityAnimation.toValue = 0
                opacityAnimation.duration = duration
                opacityAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                tickCircleLayer.add(opacityAnimation, forKey: opacityAnimation.keyPath)
                whiteTickLayer.add(opacityAnimation, forKey: opacityAnimation.keyPath)
                
                let strokeEnd1Animation = CABasicAnimation(keyPath: "strokeEnd")
                strokeEnd1Animation.duration = duration
                strokeEnd1Animation.toValue = 0
                strokeEnd1Animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                rightCircleLayer.add(strokeEnd1Animation, forKey: strokeEnd1Animation.keyPath)
                
                let strokeEnd2Animation = CABasicAnimation(keyPath: "strokeEnd")
                strokeEnd2Animation.duration = duration
                strokeEnd2Animation.toValue = 0.5
                strokeEnd2Animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                leftCircleLayer.add(strokeEnd2Animation, forKey: strokeEnd2Animation.keyPath)
                
                
            }
            else {
                addToFetched(tableView.indexPath(for: cell)!)
            }
        }
    }
    
    func addToFetched(_ indexPath: IndexPath) {
        
        didJustDelete = true
        self.navigationItem.rightBarButtonItem = nil
        let reserveIndexPath = currentIndexPath
        currentIndexPath = IndexPath(item: reserveIndexPath.row - 1, section: 0)
        (tableView.cellForRow(at: indexPath) as! TableViewCell).itemField.resignFirstResponder()
        let removedItem = items[indexPath.row]
        items.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        fetchedItems.insert(removedItem, at: 0)
        tableView.insertRows(at: [IndexPath(item: 0, section: 1)], with: .automatic)
        didJustDelete = false
    }
    
    
    
    
    @IBAction func didEndOnExit(_ sender: UITextField) {
        
    }
    
    
    
    @IBAction func didFinishEditing(_ sender: UITextField) {
        
        print(items)
        
        sender.isUserInteractionEnabled = false
        if !didJustDelete && sender.text != "" {
            if currentIndexPath.row == items.count {
                
                items.append(sender.text!)
                
                let indexPath = IndexPath(item: items.count, section: 0)
                
                tableView.insertRows(at: [indexPath], with: .automatic)
                
                if currentIndexPath.row < items.count {
                    let cell = tableView.cellForRow(at: IndexPath(item: items.count - 1, section: 0))
                    
                    let recognizer = UIPanGestureRecognizer(target: self, action: #selector(ShoppingListTableViewController.panDidActivate(_:)))
                    recognizer.delegate = cell
                    cell!.addGestureRecognizer(recognizer)
                }
            }
                
            else {
                //sender.resignFirstResponder()
               
                items[currentIndexPath.row] = sender.text!
                
                
                tableView.reloadData()
                
            }
            
        }
        else {
            if currentIndexPath.row < items.count && sender.text == "" && !aboutToDelete {
                deleteItem()
            }
        }
        
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let currentCell = tableView.cellForRow(at: indexPath) as! TableViewCell
            let textField = currentCell.itemField
            textField?.isUserInteractionEnabled = true
            textField?.becomeFirstResponder()
            
            currentIndexPath = indexPath
            if indexPath.row < items.count {
                let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(ShoppingListTableViewController.deleteItem))
                
                self.navigationItem.rightBarButtonItem = deleteButton
                
            }
            else {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
        else {
            
        }
        
    }
    
    var didJustDelete = false
    
    var aboutToDelete = false
    
    func deleteItem() {
        didJustDelete = true
        
        aboutToDelete = true
        
        items.remove(at: currentIndexPath.row)
        
        (tableView.cellForRow(at: currentIndexPath) as! TableViewCell).itemField.resignFirstResponder()
        
        tableView.deleteRows(at: [currentIndexPath], with: .automatic)
        
        if tableView.numberOfRows(inSection: 0) == 1 || currentIndexPath.row == items.count {
            
            self.navigationItem.rightBarButtonItem = nil
            
        }
        
        
        didJustDelete = false
        aboutToDelete = false
        
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }*/
    
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
     <#code#>
     }*/
    
    
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
