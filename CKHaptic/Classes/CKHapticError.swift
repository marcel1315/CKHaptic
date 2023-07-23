//
//  CKHapticError.swift
//  CKHaptic
//
//  Created by Marcel on 2023/07/22.
//

public enum CKHapticError: Error {
    case hapticNotSupported
    case eventRawStringInvalid
    case eventRawStringShouldBeUnderMaxSupport(support: Int)
    case eventEmptyError
    case eventRawStringLengthNotMatch
    case intensityRangeInvalid
    case sharpnessRangeInvalid
    case durationShoudBeOverZero
    case durationShoudBeUnderMaxSupport(support: Double)
    case eventToHapticConversionError(error: Error)
    case hapticEngineError(error: Error)
}

extension CKHapticError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .hapticNotSupported:
            return "Haptic is not supported on this device"
        case .eventRawStringInvalid:
            return "Pattern string is invalid"
        case .eventRawStringShouldBeUnderMaxSupport(let support):
            return "Pattern string should be under \(support) length"
        case .eventEmptyError:
            return "Event is empty"
        case .eventRawStringLengthNotMatch:
            return "Pattern length does not match"
        case .intensityRangeInvalid:
            return "Intensity range is invalid"
        case .durationShoudBeOverZero:
            return "Duration should be over zero"
        case .durationShoudBeUnderMaxSupport(let support):
            return "Duration should be under \(support) characters"
        case .sharpnessRangeInvalid:
            return "Sharpness range is invalid"
        case .eventToHapticConversionError(let error):
            return "Event to haptic conversion error: \(error.localizedDescription)"
        case .hapticEngineError(let error):
            return "Haptic engine error: \(error.localizedDescription)"
        }
    }
    
    public var underlyingError: Error? {
        switch self {
        case .eventToHapticConversionError(let error):
            return error
        case .hapticEngineError(let error):
            return error
        default:
            return nil
        }
    }
}
