//
//  CKHaptic.swift
//  CKHaptic
//
//  Created by Marcel on 2023/07/22.
//

import CoreHaptics

/// Use shared instance. Play an array of `CKHapticEvent`.
public class CKHaptic {
    
    private let hapticDurationInSecondMaxSupport: Double = 3600
    
    /// `CKHaptic` shared instance. Use this for playing haptic.
    public static let shared = CKHaptic()
    
    private init() {}
    
    private var hapticEngine: CHHapticEngine?
    
    private func getHapticEngine() throws -> CHHapticEngine {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        guard hapticCapability.supportsHaptics else {
            throw CKHapticError.hapticNotSupported
        }
        
        if let hapticEngine = self.hapticEngine {
            return hapticEngine
        } else {
            let hapticEngine: CHHapticEngine
            do {
                hapticEngine = try CHHapticEngine()
            } catch {
                throw CKHapticError.hapticEngineError(error: error)
            }
            
            hapticEngine.isAutoShutdownEnabled = true
            self.hapticEngine = hapticEngine
            return hapticEngine
        }
    }
    
    /// Plays `CKHapticEvent`s events at the same time for the specified duration.
    ///
    /// - Parameters:
    ///   - events: An array of `CKHapticEvent`. All events raw string length should be the same.
    ///   - duration: A duration of haptic in seconds or milliseconds. It must be greater than 0.
    ///
    /// - Throws: `CKHapticError`
    public func play(events: [CKHapticEvent], duration: CKHapticTime) throws {
        
        try validate(events: events)
        
        try validate(duration: duration)
        
        let hapticEngine = try getHapticEngine()
        
        let chHapticEvents: [CHHapticEvent] = events.flatMap { event in
            if let event = event as? CKHapticBeat {
                return event.convertToCHHapticEvent(duration: duration)
            } else if let event = event as? CKHapticBuzz {
                return event.convertToCHHapticEvent(duration: duration)
            } else {
                return []
            }
        }
        
        let pattern: CHHapticPattern
        do {
            pattern = try CHHapticPattern(events: chHapticEvents, parameters: [])
        } catch {
            throw CKHapticError.eventToHapticConversionError(error: error)
        }
        
        do {
            try hapticEngine.start()
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            throw CKHapticError.hapticEngineError(error: error)
        }
    }
}

// MARK: - Validation

extension CKHaptic {
    
    private func validate(events: [CKHapticEvent]) throws {
        guard let firstEvent = events.first else {
            throw CKHapticError.eventEmptyError
        }
        
        let firstEventLength = firstEvent.rawString.count
        
        for length in events.map({ $0.rawString.count }) {
            if length != firstEventLength {
                throw CKHapticError.eventRawStringLengthNotMatch
            }
        }
    }
    
    private func validate(duration: CKHapticTime) throws {
        if duration.valueInSeconds <= 0 {
            throw CKHapticError.durationShoudBeOverZero
        } else if duration.valueInSeconds > hapticDurationInSecondMaxSupport {
            throw CKHapticError.durationShoudBeUnderMaxSupport(support: hapticDurationInSecondMaxSupport)
        }
    }
}
