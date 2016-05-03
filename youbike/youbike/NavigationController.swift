//
//  NavigationController.swift
//  youbike
//
//  Created by Ian on 4/25/16.
//  Copyright © 2016 AppWorks School Ian Cheng. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.barTintColor = UIColor.ybkCharcoalGreyColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.ybkPaleGoldColor(), NSFontAttributeName: UIFont.ybkTextStyle2Font(17)!]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
