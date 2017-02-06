//
//  SingleItemViewController.swift
//  demo
//
//  Created by dusan vesic on 06/02/2017.
//  Copyright © 2017 dusan vesic. All rights reserved.
//

import UIKit

class SingleItemViewController: UIViewController {

    var item: Item?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!

    @IBOutlet weak var itemImage: UIImageView!
    
    override func viewDidLoad() {
        
        self.title = "hello"
        
        self.itemLabel.text = item?.title
        self.descriptionLabel.text = item?.description

        // async
        self.loadImage()
        
        /*
        let url = URL(string: (self.item?.image)!)
        let data = try? Data(contentsOf: url!)
        self.itemImage.image = UIImage(data: data!)
        */
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
            DispatchQueue.main.async {
                self.itemImage.image = UIImage(data: data!)
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
            }
        }.resume()
    }

}
