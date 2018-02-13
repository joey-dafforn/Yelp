//
//  ViewController.swift
//  FortniteAPI
//
//  Created by Joseph Davey on 1/24/18.
//  Copyright © 2018 Joseph Davey. All rights reserved.
//

import UIKit
//import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var survivalTimeLabel: UILabel!
    @IBOutlet weak var killsLabel: UILabel!
    
    //var games:
    var username = ""
    var wins = ""
    var survivalTime = ""
    var kills = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        getStats()
    }
    
    func getStats() {
        let urlString = URL(string: "https://api.fortnitetracker.com/v1/profile/xbl/Gatekeeper21")
        var req: URLRequest = URLRequest.init(url: urlString!)
        req.setValue("7c57a9c5-6600-4e0f-a292-74a02cc1bcb6", forHTTPHeaderField: "TRN-Api-Key")
        
    
            let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        do{
                            if let json = try JSONSerialization.jsonObject(with: usableData, options: .allowFragments) as? [String: Any] {
                                self.username = json["epicUserHandle"]! as! String
                                let lifetimeStats = json["lifeTimeStats"] as! [[String: Any]]
                                for stat in lifetimeStats {
                                    if (stat["key"] as! String) == "Wins" {
                                        self.wins = stat["value"]! as! String
                                    }
                                    else if (stat["key"] as! String) == "Avg Survival Time" {
                                        self.survivalTime = stat["value"]! as! String
                                    }
                                    else if (stat["key"] as! String) == "Kills" {
                                        self.kills = stat["value"]! as! String
                                    }
                                }
                            }
                        } catch {
                            print("error in JSONSerialization")
                        }
                    }
                }
                OperationQueue.main.addOperation {
                    self.usernameLabel.text = self.username
                    self.winsLabel.text = "Wins: \(self.wins)"
                    self.killsLabel.text = "Kills: \(self.kills)"
                    self.survivalTimeLabel.text = "Survival Time: \(self.survivalTime)"
                }
            }
            task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

