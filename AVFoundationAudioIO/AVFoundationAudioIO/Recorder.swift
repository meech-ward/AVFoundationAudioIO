//
//  Recorder.swift
//  AVFoundationAudioIO
//
//  Created by Sam Meech-Ward on 2018-01-14.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import Foundation
import AVFoundation
import AudioIO

public class Recorder: NSObject {
  
  private var _audioRecorder: AVAudioRecorder!
  
  private var errorRecording = false
  private var audioRecorderDidFinishRecordingClosure: ((_ recorder: AVAudioRecorder, _ successfully: Bool) -> (Void))?
  
  public var isRecording: Bool {
    return _audioRecorder.isRecording
  }
  
  /**
   Create a new instance
   
   - parameter: fileName the name of the file that will be created for the recording. This will be in the default docuemnts directory. Should end in .m4a
   */
  public init(fileName: String) throws  {
    
    super.init()
    
    let settings = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 12000,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    do {
      let audioFilePath = getDocumentsDirectory().appendingPathComponent(fileName)
      self._audioRecorder = try AVAudioRecorder(url: audioFilePath, settings: settings)
      self._audioRecorder.delegate = self
      
    } catch let error {
      print("Error \(error)")
      throw(error)
    }
  }
  
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
  }
}

extension Recorder: AVAudioRecorderDelegate {
  public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
    if let _ = error {
      errorRecording = true
    }
  }
  
  public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if flag == false {
      errorRecording = true
    }
    
    audioRecorderDidFinishRecordingClosure?(recorder, !errorRecording)
  }
}

extension Recorder: AudioRecordable {
  public var currentTime: TimeInterval {
    return _audioRecorder.currentTime
  }
  
  public func start(closure: @escaping ((Bool) -> ())) {
    _audioRecorder.prepareToRecord()
    _audioRecorder.isMeteringEnabled = true
    let successfull = _audioRecorder.record()
    closure(successfull)
  }
  
  public func stop(closure: @escaping ((Bool) -> ())) {
    self.audioRecorderDidFinishRecordingClosure = { recorder, successfully in
      closure(successfully)
    }
    _audioRecorder.stop()
  }
}

extension Recorder: AudioPowerTracker {
  public func averageDecibelPower(forChannel channelNumber: Int) -> Float {
    _audioRecorder.updateMeters()
    return _audioRecorder.averagePower(forChannel:channelNumber)
  }
}
