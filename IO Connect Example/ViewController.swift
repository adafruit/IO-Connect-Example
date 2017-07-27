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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAccelerometerX()
    }

      
    @IBOutlet weak var accelTagX: UILabel!
    
    @IBOutlet weak var accelSwitch: UISwitch!
    
    @IBAction func stateChange(_ sender: UISwitch) {
        if (sender.isOn == true){
            startAccelerometerX()
            
        }else {
            stopAccelerometerX()
        }
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

    
    func postAccelerometerDataX() {
        
        let parameters = ["value": "\(String(format: "%.02f", (motionManager.accelerometerData?.acceleration.x)!))"]
        guard let url = URL(string: "https://io.adafruit.com/api/feeds/incoming/data.json?X-AIO-Key=c04d002a910e4eff85e6b83203d4e287") else { return }
        
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

