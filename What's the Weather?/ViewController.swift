//
//  ViewController.swift
//  What's the Weather?
//
//  Created by Mike Choe on 10/11/16.
//  Copyright © 2016 cheezy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var citytext: UITextField!
    
    @IBOutlet weak var weathertext: UILabel!
    
    @IBAction func submitPressed(_ sender: AnyObject) {
        if let url = URL(string: "http://www.weather-forecast.com/locations/"+citytext.text!.replacingOccurrences(of: " ", with: "-")+"/forecasts/latest") {
        
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var message = ""
            
            //check if there's an error
            if error != nil {
                print (error)
            } else {
                
                if let unwrappedData = data {
                    
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    
                    var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                    
                    if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                        
                        if contentArray.count > 1 {
                            
                            stringSeparator = "</span>"
                            
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                            
                            if newContentArray.count > 1 {
                                
                                message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                
                                //print(message)
                            }
                            
                        }
                    }
                }
            }
            
            if message == "" {
                
                message = "The weather there couldn't be found. Please input valid city."
            }
            
            DispatchQueue.main.sync(execute: {
                self.weathertext.text = message //refer to viewcontroller
            })
            
            
        }
        
        //get the task going
        task.resume()
        } else {
            
            weathertext.text = "The weather there couldn't be found. Please input valid city."

        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }


}

