

import UIKit
import CoreData

class PlacesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    
    var places: [Places] = []
    var searchResult: [Places] = []
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>!
    var searchController: UISearchController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search Places..."
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                places = fetchResultController.fetchedObjects as! [Places]
            } catch {
                print(error)
            }
        }
        
        
        
        
        // delete  back
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // maschtab
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResult.count
        } else {
            return places.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        
        let place = (searchController.isActive) ? searchResult[indexPath.row] : places[indexPath.row]
        
        
        // opshion our cell
        cell.nameLabel.text = place.name
        cell.thumbnailImageView.image = UIImage(data: place.image! as Data)
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        
        
        if let isVisited = place.isVisited?.boolValue {
            cell.accessoryType = isVisited ? .checkmark : .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let _newIndexPath = newIndexPath {
                tableView.insertRows(at: [_newIndexPath], with: .fade)
            }
        case .delete:
            if let _newIndexPath = newIndexPath {
                tableView.deleteRows(at: [_newIndexPath], with: .fade)
            }
        case .update:
            if let _newIndexPath = newIndexPath {
                tableView.reloadRows(at: [_newIndexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        places = controller.fetchedObjects as! [Places]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //Social
        let shareAction = UITableViewRowAction(style: .default, title: "Share", handler: { (actin, indexPath) -> Void in
            let defaultText = "Just checking in at " + self.places[indexPath.row].name
            let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        })
        
        //Delete
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {(actin, indexPath) -> Void in
            self.places.remove(at: indexPath.row)
            
            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                let placeToDelete = self.fetchResultController.object(at: indexPath) as! Places
                
                managedObjectContext.delete(placeToDelete)
                tableView.deleteRows(at: [indexPath], with: .fade)
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
            
            
            
        })
        
        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! DetailViewController
                destinationController.place = places[indexPath.row]
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
        //prefersStatusBarHidden
    }
    
    @IBAction   func unwindToPlaces(segue: UIStoryboardSegue){
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(searchText)
            tableView.reloadData()
        }
    }
    
    func filterContent(_ searchText: String) {
        searchResult = places.filter({ (place: Places) -> Bool in
            let nameMatch = place.name.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let locationMatch = place.location.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            
            return nameMatch != nil || locationMatch != nil
        })
    }
    
    
}
