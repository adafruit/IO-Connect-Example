//
//  ViewController.swift
//  IO Connect Example
//
//  Created by Trevor Beaton on 7/24/17.
//  Copyright © 2017 Vanguard Logic LLC. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    
    var motionManager = CMMotionManager()
    
    @IBOutlet weak var accelTagX: UILabel!
    
    @IBOutlet weak var accelSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAccelerometerX()
        self.accelTagX.text = "--"

    }

    
    
    func startAccelerometerX () {
        print("Start Acceleromter Updates")
        motionManager.accelerometerUpdateInterval = 2.5
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {
            (accelerData:CMAccelerometerData?, error: Error?) in
            if (error != nil ) {
                print("Error")
            } else {
                
                let accelX = accelerData?.acceleration.x
                self.accelTagX.text = String(format: "%.02f", accelX!)
                self.postAccelerometerDataX()
                print("Accelerometer X: \(accelX!)")
            }
        })
    }

    func stopAccelerometerX () {
        self.motionManager.stopAccelerometerUpdates()
        self.accelTagX.text = "--"
        print("Accelerometer X Stopped")
    }

    
    
    
    
    
    /*
     //for accelerometer x
     @IBAction func stateChange(_ sender: UISwitch) {
     if (sender.isOn == true){
     self.aSwitchY.setOn(false, animated: true)
     self.aSwitchZ.setOn(false, animated: true)
     startAccelerometerX()
     
     }else {
     stopAccelerometerX()
     }
     }
     

 */
    
    func postAccelerometerDataX() {
        
        let parameters = ["value": "\(String(format: "%.02f", (motionManager.accelerometerData?.acceleration.x)!))"]
        guard let url = URL(string: "https://io.adafruit.com/api/feeds/your-Feed-Key-Here/data.json?X-AIO-Key=Your-A-IO-Key-Here") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            }.resume()
    }

    
    

}

