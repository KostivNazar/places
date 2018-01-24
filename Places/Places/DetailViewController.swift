import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet var placeImageView: UIImageView!
    @IBOutlet var tableView:UITableView!
    var place: Places!
    
    var placeImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add action
        placeImageView.image = UIImage(data: place.image! as Data)
        
        // change color TableView
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        
        // delete empty cell
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // change color
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        // change title in navigationBar
        title = place.name
        
        // Maschtab
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let rating = place.rating, rating != "" {
            rateButton.setImage(UIImage(named: place.rating!), for: UIControlState())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Data Source Protocol
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlaceDetailCell
        
        // option cell
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = place.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = place.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = place.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = place.phoneNumber
        case 4:
            cell.fieldLabel.text = "Been here"
            
            if let isVisited = place.isVisited?.boolValue{
            cell.valueLabel.text = isVisited ? "Yes" : "No"
            }
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
        }
            
    func close(_ segue: UIStoryboardSegue) {
        if let retingVC = segue.source as? RateViewController {
            if let rating = retingVC.rating {
            place.rating = rating //***
                rateButton.setImage(UIImage(named: rating), for: UIControlState())
                }
            }
        }
            
            // MARK: - Navigation
            // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationViewController = segue.destination as! MapViewController
            destinationViewController.place = place
                }
            }
}
