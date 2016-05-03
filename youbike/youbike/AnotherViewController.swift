//
//  AnotherViewController.swift
//  youbike
//
//  Created by Ian on 5/3/16.
//  Copyright © 2016 AppWorks School Ian Cheng. All rights reserved.
//

import UIKit

class AnotherViewController: UIViewController, StationDelegate {

    var stationModel = StationModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stationModel.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataDidFinishFetching() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
