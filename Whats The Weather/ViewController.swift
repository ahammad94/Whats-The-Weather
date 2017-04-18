//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Abdelrahman Hammad on 4/17/17.
//  Copyright © 2017 Abdelrahman Hammad. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        extractWeather("London")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getWeather(_ sender: Any) {
        
        extractWeather(cityTextField.text!)
    }
    
    internal func extractWeather(_ location: String){
        resultLabel.text="Loading..."
        let cleanedLocation = location.components(separatedBy: " ").joined()
        if let url = URL(string: "http://www.weather-forecast.com/locations/"+cleanedLocation+"/forecasts/latest"){
        let request = NSMutableURLRequest(url:url)
        var message = ""
        let task = URLSession.shared.dataTask(with:request as URLRequest){
            data, responce, error in
            if error != nil {
                print(error ?? "Error")
            }else{
                if let unwrappedData = data {
                    let dataString = NSString(data:unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    if (dataString?.contains("You may have mistyped"))!  {
                        message = "Please enter a valid city"
                    } else {
                        let stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        if let contentArray = dataString?.components(separatedBy: stringSeparator){
                            let secondSeparator = "</span></span></span></p><div class=\"forecast-cont\">"
                            let summary = contentArray[1].components(separatedBy: secondSeparator)
                            message = summary[0]
                        
                        }
                    }
                }
            }
            
            DispatchQueue.main.sync(execute:{
                self.resultLabel.text = message
            })
        
        }
        task.resume()
        
        } else {
            resultLabel.text = "Cannot get weather"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}

