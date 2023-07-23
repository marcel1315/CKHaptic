//
//  CKHapticPlayTests.swift
//  CKHaptic
//
//  Created by Marcel on 2023/07/22.
//

import CKHaptic
import XCTest

class CKHapticPlayTests: XCTestCase {
    
    func test_play_empty_event() {
        XCTAssertThrowsError(try CKHaptic.shared.play(events: [], duration: .seconds(1))) { error in
            XCTAssertTrue(error.localizedDescription.contains("Event is empty"))
        }
    }
    
    func test_play_different_raw_string_length() {
        let events: [CKHapticEvent] = [
            try! CKHapticBeat.create("__||___", intensity: 1, sharpness: 1),
            try! CKHapticBuzz.create("__---___", intensity: 1, sharpness: 1)
        ]
        
        XCTAssertThrowsError(try CKHaptic.shared.play(events: events, duration: .seconds(1))) { error in
            XCTAssertTrue(error.localizedDescription.contains("Pattern length does not match"))
        }
    }
    
    func test_play_same_shape_events() {
        let events: [CKHapticEvent] = [
            try! CKHapticBuzz.create("__---___", intensity: 1, sharpness: 1),
            try! CKHapticBuzz.create("__---___", intensity: 1, sharpness: 1),
            try! CKHapticBuzz.create("__---___", intensity: 1, sharpness: 1),
            try! CKHapticBuzz.create("__---___", intensity: 1, sharpness: 1)
        ]
        
        XCTAssertNoThrow(try CKHaptic.shared.play(events: events, duration: .seconds(1)))
    }
    
    func test_play_complex_events() {
        let rawString1 = Array<String>(repeating: "--__", count: 64).joined()
        let rawString2 = Array<String>(repeating: "|___", count: 64).joined()
        
        let events: [CKHapticEvent] = [
            try! CKHapticBuzz.create(rawString1, intensity: 1, sharpness: 1),
            try! CKHapticBeat.create(rawString2, intensity: 1, sharpness: 1),
            try! CKHapticBuzz.create(rawString1, intensity: 1, sharpness: 1),
        ]
        
        XCTAssertNoThrow(try CKHaptic.shared.play(events: events, duration: .seconds(10)))
    }
    
    // In test, just send events to CoreHaptics and then finish. It doesn't wait 3600 seconds.
    func test_play_long_events() {
        let rawString = Array<String>(repeating: "--__", count: 64).joined()
        let events: [CKHapticEvent] = [
            try! CKHapticBuzz.create(rawString, intensity: 1, sharpness: 1)
        ]
        
        XCTAssertNoThrow(try CKHaptic.shared.play(events: events, duration: .seconds(3600)))
        XCTAssertThrowsError(try CKHaptic.shared.play(events: events, duration: .seconds(3601))) { error in
            XCTAssertTrue(error.localizedDescription.contains("Duration should be under"))
            
        }
    }
    
    func test_play_invalid_duration() {
        let events: [CKHapticEvent] = [
            try! CKHapticBuzz.create("__--__", intensity: 1, sharpness: 1),
        ]
        
        XCTAssertThrowsError(try CKHaptic.shared.play(events: events, duration: .seconds(-1))) { error in
            XCTAssertTrue(error.localizedDescription.contains("Duration should be over zero"))
        }
    }
    
    func test_play_in_milliseconds() {
        let events: [CKHapticEvent] = [
            try! CKHapticBuzz.create("__--__", intensity: 1, sharpness: 1),
        ]
        
        XCTAssertNoThrow(try CKHaptic.shared.play(events: events, duration: .milliseconds(100)))
    }

    func test_play_multiple_times() {
        let events1: [CKHapticEvent] = [
            try! CKHapticBuzz.create("__---___", intensity: 1, sharpness: 1)
        ]
        let events2: [CKHapticEvent] = [
            try! CKHapticBuzz.create("__---___", intensity: 1, sharpness: 1)
        ]
        let events3: [CKHapticEvent] = [
            try! CKHapticBeat.create("__|_|___", intensity: 1, sharpness: 1)
        ]

        XCTAssertNoThrow(try CKHaptic.shared.play(events: events1, duration: .seconds(1)))
        XCTAssertNoThrow(try CKHaptic.shared.play(events: events2, duration: .seconds(1)))
        XCTAssertNoThrow(try CKHaptic.shared.play(events: events3, duration: .seconds(1)))
    }
}
