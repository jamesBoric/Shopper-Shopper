import UIKit

import CoreData

class RootTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    var fetchController: NSFetchedResultsController = NSFetchedResultsController()
    
    let plusButton = UIButton()
    
    var shouldBeAtSection: Int = 0
    
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
    
    var upcomingLists: [NSManagedObject] = []
    
    var passedLists: [NSManagedObject] = []
   
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 25 / 256, green: 174 / 256, blue: 255 / 256, alpha: 1)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        if shouldMoveToCreate {
        
            performSegue(withIdentifier: "a", sender: self)
            
            shouldMoveToCreate = false
        
        }

        tabBarController?.selectedIndex = shouldBeAtSection

        navigationController?.navigationBar.barTintColor = UIColor(red: 230 / 255, green: 81 / 255, blue: 0 / 255, alpha: 1)
        
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
            
            let shoppingDate = contextObject.value(forKey: "shoppingDate") as! Date
            
            let timeDifference = shoppingDate.timeIntervalSince(Date())
            
            let numOfDaysLeft = Int(round(timeDifference / 60 / 60 / 24))
            
            if numOfDaysLeft >= 0 {
               
                upcomingLists.append(contextObject)
            
            }
            
            else {
            
                passedLists.append(contextObject)
            
            }
        
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
    }

    let addButtonBackgroundColour = UIColor(red: 255 / 255, green: 214 / 255, blue: 0 / 255, alpha: 1)
    
    let addButtonHeight: CGFloat = 70
    
    override func viewDidAppear(_ animated: Bool) {
       
        super.viewDidAppear(animated)
        
        let tableHeight = CGFloat(tableView.numberOfRows(inSection: 0))

        plusButton.frame = CGRect(
            x: view.frame.size.width - 80,
            y: 44 * tableHeight - (addButtonHeight - 5) / 2,
            width: addButtonHeight,
            height: addButtonHeight
        )
        plusButton.backgroundColor = addButtonBackgroundColour
        plusButton.layer.cornerRadius = addButtonHeight / 2
        plusButton.layer.zPosition = 999
        plusButton.addTarget(self, action: #selector(RootTableViewController.didPressCreateNewList(_:)), for: .touchUpInside)
        
        let plusButtonImage = UIImageView(frame: CGRect(x: (plusButton.frame.size.width - 22) / 2, y: (plusButton.frame.size.height - 22) / 2, width: 22, height: 22))
        
        plusButtonImage.image = UIImage(named: "addButton")
        
        tableView.addSubview(plusButton)
        plusButton.addSubview(plusButtonImage)
        
        let chose = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 64))
        chose.barTintColor = UIColor(red: 255 / 255, green: 81 / 255, blue: 0 / 255, alpha: 1)
        let thing = UINavigationItem(title: "Shopper Shopper")
        chose.items = [thing]
        chose.layer.zPosition = 999
        view.superview?.addSubview(chose)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func didPressCreateNewList(_ sender: UIButton) {
        let currentPositionInFrame = CGRect(x: plusButton.frame.origin.x, y: plusButton.frame.origin.y - tableView.contentOffset.y, width: plusButton.frame.size.width, height: plusButton.frame.size.height)
        
        navigationController?.navigationBar.layer.zPosition = -1
        
        let sample = UIView(frame: currentPositionInFrame)
        
        sample.backgroundColor = addButtonBackgroundColour
        
        sample.layer.cornerRadius = plusButton.layer.cornerRadius
        
        sample.layer.zPosition = 9999
        
        view.superview?.addSubview(sample)
        
        let radius = sqrt(pow(view.frame.size.width, 2) + pow(view.frame.size.height, 2)) / 2
        
        UIView.animate(withDuration: 0.45, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: ({
            sample.frame = CGRect(x: self.view.frame.size.width / 2 - radius, y: self.view.frame.size.height / 2 - radius, width: radius * 2, height: radius * 2)
            
            sample.backgroundColor = UIColor.white
            
            
            
            
        }),completion: { (Bool) in
            self.performSegue(withIdentifier: "a", sender: self)
        })
        
        let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnimation.fromValue = plusButton.layer.cornerRadius
        cornerRadiusAnimation.toValue = radius
        cornerRadiusAnimation.duration = 0.45
        cornerRadiusAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        sample.layer.add(cornerRadiusAnimation, forKey: "cornerRadius")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 5
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return upcomingLists.count
        }
        
        return passedLists.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        //((fetchController.objectAtIndexPath(indexPath) as! NSManagedObject).valueForKey("shoppingDate") as! NSDate).compare(NSDate()) == NSComparisonResult.OrderedDescending
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "upcomingIdentifier", for: indexPath) as UITableViewCell!
            
            cell.textLabel?.text = upcomingLists[indexPath.row].value(forKey: "name") as? String
            
        }
            
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "listsIdentifier", for: indexPath) as UITableViewCell!
            cell.textLabel?.text = passedLists[indexPath.row].value(forKey: "name") as? String
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderColour = UIView()
        sectionHeaderColour.backgroundColor = UIColor(red: 255 / 255, green: 165 / 255, blue: 38 / 255, alpha: 1)
        return sectionHeaderColour
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }*/
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if indexPath.section == 0 {
                context.delete(upcomingLists[indexPath.row])
                upcomingLists.remove(at: indexPath.row)
            }
                
            else {
                context.delete(passedLists[indexPath.row])
                passedLists.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.plusButton.frame = CGRect(
                    x: self.view.frame.size.width - 80,
                    y: 44 * CGFloat(tableView.numberOfRows(inSection: 0)) - (self.addButtonHeight - 5) / 2,
                    width: self.addButtonHeight,
                    height: self.addButtonHeight
                )
                }
            )

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "upcomingListsSegue" {
            let listView = segue.destination as! ShoppingListTableViewController
            
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            
            let currentlySelectedList = upcomingLists[indexPath!.row]
            
            listView.shoppingListObject = currentlySelectedList
            listView.objectIndexPath = indexPath
            
        }
        
        else if segue.identifier == "passedListIdentifier" {
            let listView = segue.destination as! ShoppingListTableViewController
            
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            
            let currentlySelectedList = passedLists[indexPath!.row]
            
            listView.shoppingListObject = currentlySelectedList
            listView.objectIndexPath = IndexPath(item: indexPath!.row + upcomingLists.count, section: 0)
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
