import UIKit

class SingleItemViewController: UIViewController {

    // item placeholder
    var item: Item?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    override func viewDidLoad() {
        
        self.title = "Single Item"
        
        self.itemLabel.text = item?.title
        self.descriptionLabel.text = item?.description

        // async image load
        self.loadImage()
        
        // sync image load
        /*
        let url = URL(string: (self.item?.image)!)
        let data = try? Data(contentsOf: url!)
        self.itemImage.image = UIImage(data: data!)
        */
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    
    }
    
    func loadImage() {
    
        let url = URL(string: (self.item?.image)!)
        let req = URLRequest(url: url!)
        
        URLSession.shared.dataTask(with: req) {
            (data, response, error) in
            // update UI from background
            DispatchQueue.main.async {
                self.itemImage.image = UIImage(data: data!)
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
            }
        }.resume()
        
    }
    
}
