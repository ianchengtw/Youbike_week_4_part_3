//
//  RootViewController.swift
//  youbike
//
//  Created by Ian on 4/25/16.
//  Copyright © 2016 AppWorks School Ian Cheng. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController, CellDelegation, StationDelegate {
    
    var stationModel = StationModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationController?.navigationBar.topItem?.title = "YouBike"

        let nib = UINib(nibName: StationCell.identifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: StationCell.identifier)
        
        self.stationModel.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let completionHandler: () -> Void = { [unowned self] in
            
            self.tableView.reloadData()
            
        }
        
        stationModel.getYoubikeDataFromServerWithCompletionHandler(completionHandler)
        

        // Advance.
        
//        stationModel.getYoubikeDataFromServerWithCompletionHandler({ [unowned self] in
//            
//            self.tableView.reloadData()
//            
//        })
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.stationModel.stations.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 122.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StationCell.identifier, forIndexPath: indexPath) as! StationCell
        
        cell.delegate = self
        
        if let station = self.stationModel.stations[indexPath.row] as? Station {
            
            cell.title.text = station.title
            cell.address.text = station.address
            cell.remainingBikes.attributedText = StationCell.getRemainingBike(station.remainingBikes)
            cell.station = station
            
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let station = self.stationModel.stations[indexPath.row]
        switchToMapViewController(station, isShowStationCell: true)
    }
    
    func cell(cell: StationCell, viewMap sender: AnyObject?) {
        switchToMapViewController(cell.station)
    }
    
    func switchToMapViewController(station: Station, isShowStationCell: Bool = false) {
        
        let mapViewCtrl = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        
        mapViewCtrl.setStationInfo(station, isShowStationCell: isShowStationCell)
        
        self.navigationController!.pushViewController(mapViewCtrl, animated: true)
        
    }
    
    func dataDidFinishFetching() {
        
        self.tableView.reloadData()
        
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
