//
//  CKHapticTime.swift
//  CKHaptic
//
//  Created by Marcel on 2023/07/22.
//

public enum CKHapticTime {
  case seconds(Double)
  case milliseconds(Double)
  
  var valueInSeconds: Double {
    switch self {
    case .seconds(let seconds):
      return seconds
    case .milliseconds(let milliseconds):
      return milliseconds / 1000
    }
  }
}
