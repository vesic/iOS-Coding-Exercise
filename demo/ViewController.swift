//
//  ViewController.swift
//  demo
//
//  Created by dusan vesic on 31/01/2017.
//  Copyright © 2017 dusan vesic. All rights reserved.
//

import UIKit
import Darwin

var items = [Item]()

/*
let item1 = Item(name: "item1")
let item2 = Item(name: "item2")
let item3 = Item(name: "item3")
*/

class ViewController: UIViewController,
        UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        
        self.title = "All Items"
        
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        
        /*
        items.append(item1)
        items.append(item2)
        items.append(item3)
        */
 
        //self.getItems();
        spinner.startAnimating()
        
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        self.loadItemsFromApi()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "myCell")
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "myCell")
        
        let item = items[indexPath.row]
        
        cell?.textLabel?.text = item.title
        
        return cell!;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        /*
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "details")
        self.present(controller!, animated: true, completion: nil)
        */
        
        let controller: SingleItemViewController = self.storyboard?.instantiateViewController(withIdentifier: "details") as! SingleItemViewController
        let itemAtRow = items[indexPath.row]
        
        controller.item = itemAtRow
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func loadItemsFromApi() {
        items = [Item]();
        
        print("loadIitems")
        
        //let url = URL(string: "https://reqres.in/api/users")!;
        let url = URL(string: DataAPI.restUrl)!
        //var req = URLRequest(url: url);
        //req.cachePolicy = .reloadRevalidatingCacheData;
        // forcing fresh request
        //req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession.shared;
        //var users = [String]()
        
        let task = session.dataTask(with: url) {
            (data, response, error) in
            
            if let jsonData = data {
                do {
                    let result = try JSONSerialization.jsonObject(with: jsonData) as! [[String: String]]
                    //print(jsonObject)
                    for single in result {
                        
                        //let title:String, image: String, descrption: String
                        let item:Item
                        
                        if let title = single["title"],
                            let image = single["image"],
                            let desc = single["description"] {
                            item = Item(title:title, image:image, description:desc)
                            print(items.count)
                        } else {
                            item = Item(title: "error", image: "error", description: "error")
                        }
                        //let item = Item(title: title, image: image, description: description)
                        
                        items.append(item)
                    }
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                        self.spinner.stopAnimating()
                        self.spinner.isHidden = true//removeFromSuperview()
                    }
                    /*
                    if let json = jsonObject["data"] as? [String: Any] {
                        if let name = json["first_name"] {
                            print(name)
                        }
                    } */
                    /*
                    for (key, value) in jsonObject! {
                        guard
                            let json = jsonObject?["data"] as? [String: Any],
                            let name = json["first_name"] as? String
                        else { return }
                        users.append(name)
                    }
                    print(users.count);
                    */
                } catch let error {
                    print("Error \(error)")
                }
                print(items.count);
            }
            
        }
        
        task.resume();
        
    }
    
}

