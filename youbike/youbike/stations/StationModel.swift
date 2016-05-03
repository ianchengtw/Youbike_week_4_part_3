//
//  StationModel.swift
//  youbike
//
//  Created by Ian on 4/25/16.
//  Copyright © 2016 AppWorks School Ian Cheng. All rights reserved.
//

import Foundation

struct Station {
    var title: String = ""
    var address: String = ""
    var remainingBikes: Int = 0
    var latitude: Double = 0.0
    var longitude: Double = 0.0
}

protocol StationDelegate: class {
    
//    func doneButtonDidClickPleasePrintSomething()
//    
//    func doneButtonDidClick()
    
    func dataDidFinishFetching()
    
}

class StationModel {
    
    private var _stations = [Station]()
    var stations: [Station] { return self._stations }
    weak var delegate: StationDelegate?
    
    init() {
        
        // getYoubikeDataFromFile()
        // sendAPostRequestToServer()
        
        
        // assign task to background queue
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//            
//            self.getYoubikeDataFromServer()
//            
//        }
        
    }
    
    func readJSONObject(object: [String: AnyObject]) {
        
        guard let stations = object["retVal"] as? [String: [String: String]] else { return }
        
        for (_, station) in stations {
            
            guard let sna = station["sna"] as? String!,
                let sSbi = station["sbi"] as? String!,
                let sbi = Int(sSbi),
                let ar = station["ar"] as? String!,
                let sLat = station["lat"] as? String!,
                let lat = Double(sLat),
                let sLng = station["lng"] as? String!,
                let lng = Double(sLng) else { continue }
            
            self._stations.append(
                Station(
                    title: sna,
                    address: ar,
                    remainingBikes: sbi,
                    latitude: lat,
                    longitude: lng
                )
            )
            
        }
    }
    
    func parseJSONObjectToModel(object: [String: AnyObject]) {
        
        guard let data = object["result"] as? [String: AnyObject],
            let stations = data["results"] as? [[String: String]] else { return }
        
        for station in stations {
            
            guard let sna = station["sna"] as? String!,
                let sSbi = station["sbi"] as? String!,
                let sbi = Int(sSbi),
                let ar = station["ar"] as? String!,
                let sLat = station["lat"] as? String!,
                let lat = Double(sLat),
                let sLng = station["lng"] as? String!,
                let lng = Double(sLng) else { continue }
            
            self._stations.append(
                Station(
                    title: sna,
                    address: ar,
                    remainingBikes: sbi,
                    latitude: lat,
                    longitude: lng
                )
            )
            
        }
        
    }
    
    func getYoubikeDataFromFile() {
        
        // read json
        let url = NSBundle.mainBundle().URLForResource("youbike", withExtension: "json")
        let data = NSData(contentsOfURL: url!)
        
        do {
            let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            if let dictionary = object as? [String: AnyObject] {
                readJSONObject(dictionary)
            }
        } catch {
            // Handle Error
        }
    }
    
    func normalFunc() -> Void {}
    
    typealias CompletionHandler = () -> Void
    
    func getYoubikeDataFromServerWithCompletionHandler(completion: CompletionHandler) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        
            let url = String("http://172.19.32.73:3000/youbikes")
            
            let req = NSMutableURLRequest(URL: NSURL(string: url)!)
            req.HTTPMethod = "GET"
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(req, completionHandler: {
                (oData: NSData?, res: NSURLResponse?, error: NSError?) in
                
                guard
                    let data = oData,
                    let httpResponse = res as? NSHTTPURLResponse
                    else { return }
                
                
                if httpResponse.statusCode != 200 {
                    print(error)
                    return
                }
                
                do {
                    let object = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    if let dictionary = object as? [String: AnyObject] {
                        self.parseJSONObjectToModel(dictionary)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            completion()
                            
                        }
                    }
                } catch {
                    // Handle Error
                }
                
            })
            
            task.resume()
            
        }
        
    }
    
    func getYoubikeDataFromServer() {
        
        let url = String("http://172.19.32.73:3000/youbikes")
        
        let req = NSMutableURLRequest(URL: NSURL(string: url)!)
        req.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (oData: NSData?, res: NSURLResponse?, error: NSError?) in
            
            guard
                let data = oData,
                let httpResponse = res as? NSHTTPURLResponse
                else { return }
            
            
            if httpResponse.statusCode != 200 {
                print(error)
                return
            }
            
            do {
                let object = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                if let dictionary = object as? [String: AnyObject] {
                    self.parseJSONObjectToModel(dictionary)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.delegate?.dataDidFinishFetching()
                        
                    }
                }
            } catch {
                // Handle Error
            }
            
        })
        
        task.resume()
    }
    
    func sendAPostRequestToServer() {
        
        let url = String("http://172.19.32.73:3000/check_in")
        let params = ["latitude": 123.0, "longitude": 567.0]
        let req = NSMutableURLRequest(URL: NSURL(string: url)!)
        req.HTTPMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            req.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(req, completionHandler: {
                (oData: NSData?, res: NSURLResponse?, error: NSError?) in
                
                guard
                    let data = oData,
                    let httpResponse = res as? NSHTTPURLResponse
                    else { return }
                
                if httpResponse.statusCode != 200 {
                    print(error)
                    return
                }
                
                print(data)
                print(httpResponse)
                
            })
            
            task.resume()
            
        } catch {
            
            print("error")
        }
    }
    
}