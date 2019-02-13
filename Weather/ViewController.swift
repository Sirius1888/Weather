//
//  ViewController.swift
//  Weather
//
//  Created by sirius on 13.02.2019.
//  Copyright © 2019 sirius. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tempImage: UIImageView!
    @IBOutlet weak var weatherState: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let urlString = "https://api.apixu.com/v1/current.json?key=53b8bd7aaa4f4b5e87e53622191302&q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))"
        let url = URL(string: urlString)
        
        var locationName: String?
        var tempCelcius: Double?
        var imageUrl: String?
        var errorHasOccured: Bool = false

        let task = URLSession.shared.dataTask(with: url!) {[weak self] (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let _ = json["error"] {
                    errorHasOccured = true
                } else {
                    if let location = json["location"] {
                        locationName = location["name"]  as? String
                        
                    }
                    
                    if let current = json["current"] {
                        tempCelcius = current["temp_c"] as? Double
                        var condition: String?
                        condition = current["condition"] as? String
            
                    }
                    errorHasOccured = false
                }
                
                
                DispatchQueue.main.async {
                    if errorHasOccured {
                        self?.cityLabel.text = "Ошибка"

                        self?.temperatureLabel.isHidden = true
                    } else {
                        self?.cityLabel.text = locationName
                        self?.temperatureLabel.text = "\(tempCelcius!) С°"
//                        self?.weatherState.text = imageUrl
                        self?.temperatureLabel.isHidden = false
                    }
                    
                }
               
            } catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
}


