import UIKit

// items store
var items = [Item]()

class ItemsViewController: UIViewController,
        UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        
        self.title = "All Items"
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        
        spinner.startAnimating()
        
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        self.loadItemsFromApi()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "myCell")
        let item = items[indexPath.row]
        cell?.textLabel?.text = item.title
        
        return cell!;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller: SingleItemViewController = self.storyboard?.instantiateViewController(withIdentifier: "details") as! SingleItemViewController
        let itemAtRow = items[indexPath.row]
        controller.item = itemAtRow
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func loadItemsFromApi() {
        
        // reset items
        items = [Item]();
        let url = URL(string: DataAPI.restUrl)!
        var req = URLRequest(url: url);
        // cache request
        req.cachePolicy = .reloadRevalidatingCacheData
        // force fresh request
        //req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        URLSession.shared.dataTask(with: req) {
            (data, response, error) in
            
            if let jsonData = data {
                do {
                    let result = try JSONSerialization.jsonObject(with: jsonData) as! [[String: String]]
                    
                    for single in result {
                        
                        let item:Item
                        
                        if let title = single["title"],
                            let image = single["image"],
                            let desc = single["description"] {
                            item = Item(title:title, image:image, description:desc)
                        } else {
                            item = Item(title: "error", image: "error", description: "error")
                        }
                        
                        items.append(item)
                    }
                    // update UI from background
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                        self.spinner.stopAnimating()
                        self.spinner.isHidden = true//removeFromSuperview()
                    }
                } catch let error {
                    print("Error \(error)")
                }
            }
        }.resume()
    }
    
}

