//
//  CKHapticEvent.swift
//  CKHaptic
//
//  Created by Marcel on 2023/07/22.
//

import CoreHaptics

// MARK: - CKHapticEvent protocol

public protocol CKHapticEvent {
    
    /// Event raw string. It differs along with Event type.
    var rawString: String { get }
    
    /// Intensity means the strength of the haptic.
    var intensity: Float { get }
    
    /// You can think of sharpness as a way to abstract a haptic experience into the waveform that produces the corresponding physical sensations. For example, you might use sharpness values to convey an experience that’s soft, rounded, or organic, or one that’s crisp, precise, or mechanical.
    var sharpness: Float { get }
    
    /// Create `CKHapticEvent`.
    static func create(_ rawString: String, intensity: Float, sharpness: Float) throws -> CKHapticEvent
}

extension CKHapticEvent {
    static var eventRawStringLengthMaxSupport: Int { 256 }
    
    static func validate(rawString: String, allowedCharacters: CharacterSet, intensity: Float, sharpness: Float) throws {
        
        if rawString.isEmpty {
            throw CKHapticError.eventRawStringInvalid
        }
        
        if rawString.count > eventRawStringLengthMaxSupport {
            throw CKHapticError.eventRawStringShouldBeUnderMaxSupport(support: eventRawStringLengthMaxSupport)
        }
        
        if !intensity.isBetweenZeroAndOne() {
            throw CKHapticError.intensityRangeInvalid
        }
        
        if !sharpness.isBetweenZeroAndOne() {
            throw CKHapticError.sharpnessRangeInvalid
        }
        
        if !rawString.unicodeScalars.allSatisfy(allowedCharacters.contains) {
            throw CKHapticError.eventRawStringInvalid
        }
    }
}

// MARK: - CKHapticBuzz

/// One of the `CKHapticEvent` type. Haptic feedback with trembling. This converts into `hapticContinuous` event type in the Core Haptics Library. The HIG explains "Continuous events feel like sustained vibrations, such as the experience of the lasers effect in a message."
public struct CKHapticBuzz: CKHapticEvent {
    
    private static var allowedCharacters: CharacterSet = .init(charactersIn: "_-")
    
    /// Event raw string. e.g. "---\_\_\_----". This means "vibrate 3 + pause 3 + vibrate 4" out of 10. If the duration of play is 1 seconds, vibrate 0.3s + pause 0.3s + vibrate 0.4s.
    public var rawString: String
    
    public var intensity: Float
    
    public var sharpness: Float
    
    private init() {
        fatalError()
    }
    
    init(_ rawString: String, intensity: Float, sharpness: Float) throws {
        try Self.validate(rawString: rawString, allowedCharacters: Self.allowedCharacters, intensity: intensity, sharpness: sharpness)
        
        self.rawString = rawString
        self.intensity = intensity
        self.sharpness = sharpness
    }
    
    /// Create CKHapticBuzz event.
    ///
    /// - Parameters:
    ///   - _ rawString: String that represents event pattern. It must contain only "\_" and "-". The length should be 1 and 256 letters. e.g. "---\_\_\_----". This means "vibrate 3 + pause 3 + vibrate 4" out of 10. If the duration of play is 1 second, vibrate 0.3s + pause 0.3s + vibrate 0.4s.
    ///   - intensity: Intensity means the strength of the haptic.
    ///   - sharpness: You can think of sharpness as a way to abstract a haptic experience into the waveform that produces the corresponding physical sensations. For example, you might use sharpness values to convey an experience that’s soft, rounded, or organic, or one that’s crisp, precise, or mechanical.
    ///
    /// - Returns: `CKHapticEvent`
    ///
    /// - Throws: `CKHapticError`
    public static func create(_ rawString: String, intensity: Float, sharpness: Float) throws -> CKHapticEvent {
        return try self.init(rawString, intensity: intensity, sharpness: sharpness)
    }
    
    /// Converts event raw string to `CHHapticEvent` that the Core Haptics can play with.
    ///
    /// - Parameter duration: `CKHapticTime` enum that has time in seconds or milliseconds.
    ///
    /// - Returns: `[CHHapticEvent]` that the system can play haptic with it.
    func convertToCHHapticEvent(duration: CKHapticTime) -> [CHHapticEvent] {
        guard duration.valueInSeconds != 0 else {
            return []
        }
        
        guard !rawString.isEmpty else {
            return []
        }
        
        var chunks: [(chunkDuration: Double, startTime: Double)] = []
        
        let unit: Double = duration.valueInSeconds / Double(rawString.count)
        var startTime: Double = 0
        var chunkDuration: Double = 0
        var lastCharacter: Character = "_"
        
        for (i, currentCharacter) in rawString.enumerated() {
            switch (lastCharacter, currentCharacter) {
            case ("_", "-"):
                startTime = Double(i) * unit
                chunkDuration = unit
            case ("_", "_"):
                break
            case ("-", "-"):
                chunkDuration += unit
            case ("-", "_"):
                chunks.append((chunkDuration: chunkDuration, startTime: startTime))
            default:
                break
            }
            lastCharacter = currentCharacter
        }
        
        if lastCharacter == "-" {
            chunks.append((chunkDuration: chunkDuration, startTime: startTime))
        }
        
        var results: [CHHapticEvent] = []
        for chunk in chunks {
            let event = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
                ],
                relativeTime: chunk.startTime,
                duration: chunk.chunkDuration
            )
            results.append(event)
        }
        
        return results
    }
}

// MARK: - CKHapticBeat

/// One of the `CKHapticEvent` type. Haptic feedback with single beat. This converts into `hapticTransient` event type in the Core Haptics Library. The HIG explains "Transient events are brief and compact, often feeling like taps or impulses. The experience of tapping the Flashlight button on the Home Screen is an example of a transient event."
public struct CKHapticBeat: CKHapticEvent {
    
    private static var allowedCharacters: CharacterSet = .init(charactersIn: "_|")
    
    /// Event raw string. e.g. "-|---------". This means "pause 1 + beat 1 + pause 8" out of 10. If the duration of play is 1 second, pause 0.1s + beat 0.1s + pause 0.8s. Beat 0.1s means just one beat and done, not beating continuously for 0.1 second.
    public var rawString: String
    
    public var intensity: Float
    
    public var sharpness: Float
    
    private init() {
        fatalError()
    }
    
    init(_ rawString: String, intensity: Float, sharpness: Float) throws {
        try Self.validate(rawString: rawString, allowedCharacters: Self.allowedCharacters, intensity: intensity, sharpness: sharpness)
        
        self.rawString = rawString
        self.intensity = intensity
        self.sharpness = sharpness
    }
    
    /// Create CKHapticBeat event.
    ///
    /// - Parameters:
    ///   - _ rawString: String that represents event pattern. It must contain only "\_" and "|". The length should be 1 and 256 letters. e.g. "-|---------". This means "pause 1 + beat 1 + pause 8" out of 10. If the duration of play is 1 second, pause 0.1s + beat 0.1s + pause 0.8s. Beat 0.1s means just one beat and done, not beating continuously for 0.1 second.
    ///   - intensity: Intensity means the strength of the haptic.
    ///   - sharpness: You can think of sharpness as a way to abstract a haptic experience into the waveform that produces the corresponding physical sensations. For example, you might use sharpness values to convey an experience that’s soft, rounded, or organic, or one that’s crisp, precise, or mechanical.
    ///
    /// - Returns: `CKHapticEvent`
    ///
    /// - Throws: `CKHapticError`
    public static func create(_ rawString: String, intensity: Float, sharpness: Float) throws -> CKHapticEvent {
        return try self.init(rawString, intensity: intensity, sharpness: sharpness)
    }
    
    /// Converts event raw string to `CHHapticEvent` that the Core Haptics can play with.
    ///
    /// - Parameter duration: `CKHapticTime` enum that has time in seconds or milliseconds.
    ///
    /// - Returns: `[CHHapticEvent]` that the system can play haptic with it.
    func convertToCHHapticEvent(duration: CKHapticTime) -> [CHHapticEvent] {
        guard duration.valueInSeconds != 0 else {
            return []
        }
        
        guard !rawString.isEmpty else {
            return []
        }
        
        let unit: Double = duration.valueInSeconds / Double(rawString.count)
        
        var results: [CHHapticEvent] = []
        for (i, p) in rawString.enumerated() {
            if p == "|" {
                let second = unit * Double(i)
                let event = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
                    ],
                    relativeTime: second
                )
                results.append(event)
            }
        }
        
        return results
    }
}

// MARK: - Private Extensions

fileprivate extension Float {
    func isBetweenZeroAndOne() -> Bool {
        return self >= 0 && self <= 1
    }
}

fileprivate extension String {
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
