






import UIKit
import SafariServices
class AboutTableViewController: UITableViewController {
    
    var sectionTitle = ["Leave Feedback", "Follow Me"]
    var sectionContent = [["Rate me on AppStore", "Give me some money"], ["Instagram", "Facebook", "VK"]]
    var links = ["http://www.thepicta.com/user/kostiv.nazar/1534582802", "https://www.facebook.com/nazar.alchemist", "https://vk.com/perfectgentelman"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionTitle.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 2
        } else {
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                if let url = URL(string: "http://apple.com") {
                    UIApplication.shared.openURL(url)
                }
            } else if indexPath.row == 1 {
                performSegue(withIdentifier: "showWebView", sender: self)
            }
        case 1:
            if let url = URL(string: links[indexPath.row]) {
                let safariView = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                present(safariView, animated: true, completion: nil)
            }
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
}
}
