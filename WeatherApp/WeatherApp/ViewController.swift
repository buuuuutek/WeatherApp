//
//  ViewController.swift
//  WeatherApp
//
//  Created by ApplePie on 24.01.18.
//  Copyright © 2018 ApplePie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let urlString = "https://api.apixu.com/v1/current.json?key=ca7e3f70acd44d428b982548182401&q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))"
        let url = URL(string: urlString)
        
        var locationName: String?
        var temterature: Double?
        var errorHasOccured: Bool = false
        
        let task = URLSession.shared.dataTask(with: url!) {[weak self] (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    as! [String: AnyObject]
                
                if let _ = json["error"] {
                    errorHasOccured = true
                }
                
                if let location = json["location"] {
                    locationName = location["name"] as? String
                }
                
                if let current = json["current"] {
                    temterature = current["temp_c"] as? Double
                }
                
                DispatchQueue.main.async {
                    if errorHasOccured {
                        self?.temperatureLabel.isHidden = true
                        self?.cityLabel.text = "Error has occured"
                    }
                    else {
                        self?.cityLabel.text = locationName
                        self?.temperatureLabel.text = String(describing: temterature!)
                        self?.temperatureLabel.isHidden = false
                    }
                    
                }
                
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        
        task.resume()
    }
}

