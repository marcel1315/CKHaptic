//
//  CKHapticEventTests.swift
//  CKHaptic
//
//  Created by Marcel on 2023/07/22.
//

import CKHaptic
import XCTest

class CKHapticEventTests: XCTestCase {
    
    func test_invalid_beat_pattern_string() {
        XCTAssertThrowsError(try CKHapticBeat.create("___-___", intensity: 1, sharpness: 1)) { error in
            XCTAssertTrue(error.localizedDescription.contains("Pattern string is invalid"))
        }
    }
    
    func test_invalid_beat_pattern_string_empty() {
        XCTAssertThrowsError(try CKHapticBeat.create("", intensity: 1, sharpness: 1)) { error in
            XCTAssertTrue(error.localizedDescription.contains("Pattern string is invalid"))
        }
    }
    
    func test_invalid_buzz_pattern_string_space() {
        XCTAssertThrowsError(try CKHapticBuzz.create(" ", intensity: 1, sharpness: 1)) { error in
            XCTAssertTrue(error.localizedDescription.contains("Pattern string is invalid"))
        }
    }
    
    func test_invalid_buzz_pattern_string_alphabet() {
        XCTAssertThrowsError(try CKHapticBuzz.create("abc abc", intensity: 1, sharpness: 1)) { error in
            XCTAssertTrue(error.localizedDescription.contains("Pattern string is invalid"))
        }
    }
    
    func test_too_long_event_raw_string() {
        let eventRawString1 = String(Array<Character>(repeating: "-", count: 255))
        let eventRawString2 = String(Array<Character>(repeating: "-", count: 256))
        let eventRawString3 = String(Array<Character>(repeating: "-", count: 257))

        XCTAssertNoThrow(try CKHapticBuzz.create(eventRawString1, intensity: 1, sharpness: 1))
        XCTAssertNoThrow(try CKHapticBuzz.create(eventRawString2, intensity: 1, sharpness: 1))
        XCTAssertThrowsError(try CKHapticBuzz.create(eventRawString3, intensity: 1, sharpness: 1)) { error in
            XCTAssertTrue(error.localizedDescription.contains("Pattern string should be under"))
        }
    }

    func test_invalid_intensity_value() {
        XCTAssertThrowsError(try CKHapticBuzz.create("___-___", intensity: -1.1, sharpness: 1)) { error in
            XCTAssertTrue(error.localizedDescription.contains("Intensity range is invalid"))
        }
    }
    
    func test_invalid_sharpness_value() {
        XCTAssertThrowsError(try CKHapticBuzz.create("___-___", intensity: 0, sharpness: -0.5)) { error in
            XCTAssertTrue(error.localizedDescription.contains("Sharpness range is invalid"))
        }
    }
}
