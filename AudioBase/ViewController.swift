//
//  ViewController.swift
//  AudioBase
//
//  Created by Chris Saunders on 2/09/2015.
//  Copyright (c) 2015 tenKinetic. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    let yinHelper = YinHelper()
    var audioEngine: AVAudioEngine?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        analyse()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func analyse()
    {
        yinHelper.frequencyClosure =
            { (Double frequency) in
            
                println("frequency recieved: \(frequency)")
        }
        yinHelper.analyse()
    }
    
    @IBAction func stop()
    {
        yinHelper.stop()
        if let audioEngine = self.audioEngine
        {
            audioEngine.stop()
        }
    }
}












