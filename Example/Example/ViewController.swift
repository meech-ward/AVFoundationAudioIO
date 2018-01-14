//
//  ViewController.swift
//  Example
//
//  Created by Sam Meech-Ward on 2018-01-12.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import UIKit
import AudioIO
import AVFoundationAudioIO

class ViewController: UIViewController {
  
  var recorder: AudioIO.AudioRecorder!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    do {
      let recordable = try AVFoundationAudioIO.Recorder(fileName: "recording.m4a")
      let timer = RecorderTimer()
      recorder = AudioIO.AudioRecorder(recordable: recordable,
                                       powerTracker: recordable,
                                       dataTimer: timer,
                                       dataClosure: { sample, recordable in
                                        print("Sample: \(sample)")
      })
    } catch {
      print("Error")
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func Record(_ sender: Any) {
    if !recorder.isRecording {
      recorder.start { success in
        if !success {
          print("Error starting recording")
        }
      }
    } else {
      recorder.stop { success in
        if !success {
          print("Error during or stopping recording")
        }
      }
    }
  }
  
}

