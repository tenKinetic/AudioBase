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
    let yh = YinHelper()
    var audioEngine: AVAudioEngine?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //swiftTestAnalyse()
        swiftAnalyse()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func swiftTestAnalyse()
    {
        self.yh.testanalyse()
        
        let pYINTest = pYin(frameSize: 2048, inputSampleRate: 44100)
        var st = UnsafeMutablePointer<Float>.alloc(2048)
        for var i = 0;i<2048;++i
        {
            st[i] = Float((i/2048)*50)
        }
        
        var up = withUnsafePointer(&st) { (pointer: UnsafePointer<UnsafeMutablePointer<Float>>) -> (UnsafePointer<UnsafeMutablePointer<Float>>) in
            //return CTFontCreatePathForGlyph(myFont, myGlyph, pointer)
            return pointer
        }
        
        pYINTest.analyse(up)
            { (output:YinOutput) in
                
                // display the frequency of highest probability
                for prob in output.freqProb
                {
                    println("swiftTestAnalyse pair:\(prob.frequency),\(prob.probability)")
                }
        }
    }
    
    @IBAction func swiftAnalyse()
    {
        /*
        yh.frequencyClosure =
            { (Double frequency) in
                println("You are probably farting at \(frequency) Hz")
        }
        yh.analyse()
        */
        self.audioEngine = AVAudioEngine()
        if let audioEngine = self.audioEngine
        {
            setMic()
            var format = audioEngine.mainMixerNode.outputFormatForBus(0)
            let pYIN = pYin(frameSize: 2048, inputSampleRate: UInt64(format.sampleRate))
            audioEngine.connect(audioEngine.inputNode, to: audioEngine.mainMixerNode, format: format)
            audioEngine.mainMixerNode.installTapOnBus(0, bufferSize: 2048, format: audioEngine.mainMixerNode.outputFormatForBus(0))
                {
                    (buffer: AVAudioPCMBuffer!, when: AVAudioTime!) -> Void in
                    
                    /*
                    REF: this is how we read / write the buffer
                    for var i:UInt64 = 0; i < UInt64(buffer.frameLength); i+=UInt64(buffer.format.channelCount)
                    {
                        self.audioBuffer.floatChannelData.memory[i] = 0.0f; // or whatever
                    }
                    */
                    
                    println(buffer.floatChannelData.memory[100]);
                    
                    pYIN.analyse(buffer.floatChannelData)
                        { (output:YinOutput) in
                            
                            // display the frequency of highest probability
                            var maxProb = 0.0
                            var frequency = 0.0
                            for prob in output.freqProb
                            {
                                if prob.probability > maxProb
                                {
                                    maxProb = prob.probability
                                    frequency = prob.frequency
                                }
                            }
                            println("You are probably farting at \(frequency) Hz, like, with \(maxProb*100)% probability")
                    }
            }
            var error:NSError?
            self.audioEngine?.startAndReturnError(&error)
            if (error != nil)
            {
                println(error)
            }
        }
    }

    @IBAction func analyse()
    {
        yh.frequencyClosure =
            { (Double frequency) in
            
                // TODO: display frequency
                println("frequency recieved: \(frequency)")
        }
        yh.analyse()
    }
    
    @IBAction func stop()
    {
        yh.stop()
        if let audioEngine = self.audioEngine
        {
            audioEngine.stop()
        }
    }
    
    func setMic()
    {
        // set input to built in mic
        let sharedSession = AVAudioSession.sharedInstance()
        sharedSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        let availableInputs = sharedSession.availableInputs
        //        println(sharedSession.category)
        //        println(sharedSession.inputAvailable)
        //        println(sharedSession.inputDataSource)
        //        println(sharedSession.availableInputs)
        //        println(sharedSession.availableInputs.count)
        if (availableInputs != nil)
        {
            for input in availableInputs
            {
                println(input.portType)
                if input.portType == AVAudioSessionPortBuiltInMic
                {
                    sharedSession.setPreferredInput(input as AVAudioSessionPortDescription, error: nil)
                }
            }
        }
    }
}












