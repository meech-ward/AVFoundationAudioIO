//
//  RecorderTimer.swift
//  Example
//
//  Created by Sam Meech-Ward on 2018-01-14.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import Foundation
import AudioIO

class RecorderTimer: TimerType {
  var timer: Timer?
  
  func start(_ block: @escaping () -> (Void)) {
    OperationQueue.main.addOperation {
      // Changing the time interval may fuck with the accuracy of the audio processing
      self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
        block()
      }
    }
  }
  
  func stop() {
    timer?.invalidate()
    timer = nil
  }
}
