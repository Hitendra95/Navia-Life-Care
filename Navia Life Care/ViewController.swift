//
//  ViewController.swift
//  Navia Life Care
//
//  Created by Hitendra Dubey on 10/09/18.
//  Copyright © 2018 Hitendra Dubey. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var trackButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view, typically from a nib.
        
        trackButton.layer.cornerRadius = 5
        trackButton.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.layer.frame.height/2
        profileImage.clipsToBounds = true
        
        profileView.layer.cornerRadius = 7
        //dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 2, scale: true)
        profileView.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 2, scale: true)
        apiCallOfnotification()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (didAllow, error) in
        }
        
        
    }
    
    
    func notification(title: String , subTitle:String)
    {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subTitle
        content.body = "Here is your prescribed meal"
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "Meal Notification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
    }
    
    
    func currentDateandItsMeal(json: [String:AnyObject])
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM"
        print("date is :\(date)")
        let result = formatter.string(from: date)
        print("date is :\(result)")
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: date)
        print("day is: \(weekDay)")
        let dictionry :[[String:Any]]?
        let data = json["week_diet_data"] as! [String:Any]
        
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        let res = format.string(from: date)
        //print("date iss \(res)")
        
        
        if weekDay == 3
        {
            dictionry = data["monday"] as? [[String : Any]]
            print("dictionary is  : \(String(describing: dictionry))")
            
            for dic in dictionry!
            {
                print("dic is \(dic) ")
                
                if res == dic["meal_time"] as? String
                {
                    notification(title: "food", subTitle: dic["food"] as! String)
                }
            }
           
        }
        
        else if weekDay == 4
        {
            dictionry = data["wednesday"] as? [[String : Any]]
            print("dic is: \(String(describing: dictionry))")
            for dic in dictionry!
            {
                print("dic is \(dic) ")
                
                if res == dic["meal_time"] as? String
                {
                    notification(title: "food", subTitle: dic["food"] as! String)
                }
            }

        }
        
        else if weekDay == 5
        {
            dictionry = data["thursday"] as? [[String : Any]]
            print("dic is :\(String(describing: dictionry))")
            
            for dic in dictionry!
            {
                print("dic is \(dic) ")
                
                if res == dic["meal_time"] as? String
                {
                    notification(title: "food", subTitle: dic["food"] as! String)
                }
            }

            
        }
        
        
        
    }
    
    func apiCallOfnotification()
    {
        
            var request = URLRequest(url:URL(string:"https://naviadoctors.com/dummy/")!)
            request.httpMethod = "GET"
            let session = URLSession.shared
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
                
                
                print("response of recent activity")
                print(response!)
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
    
                    print("json is :\(json)")
                    DispatchQueue.main.async(execute: {
                        //self.lastTable.reloadData()
                        
                        self.currentDateandItsMeal(json: json)
                        
                        
                    })
                } catch {
                    print("error")
                }
            })
            task.resume()
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func trackButtonpressed(_ sender: Any) {
    }
    
}

extension UIView
{
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        //layer.cornerRadius = 0.3
        layer.masksToBounds = false
        layer.shadowColor = color.withAlphaComponent(0.5).cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
