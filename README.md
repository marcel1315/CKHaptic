# CKHaptic

[![Version](https://img.shields.io/cocoapods/v/CKHaptic.svg?style=flat)](https://cocoapods.org/pods/CKHaptic)
[![License](https://img.shields.io/cocoapods/l/CKHaptic.svg?style=flat)](https://cocoapods.org/pods/CKHaptic)
[![Platform](https://img.shields.io/cocoapods/p/CKHaptic.svg?style=flat)](https://cocoapods.org/pods/CKHaptic)

## Feature

- Play your custom haptic feedback with ease.

## Usage

```swift
import CKHaptic

// ..

let events = [
    try CKHapticBuzz.create("---____---", intensity: 0.5, sharpness: 0.5),
    try CKHapticBeat.create("_|___|____", intensity: 1, sharpness: 1)
]

try CKHaptic.shared.play(events: events, duration: .seconds(1))
```

There are two types of haptic feedback.

- Buzz

  - Continuous haptic. The HIG(Human Interface Guideline) explains "Continuous events feel like sustained vibrations, such as the experience of the lasers effect in a message."

  - Use combinations of "-" and "_" String to represent a Buzz haptic.

    ```swift
    "---____---" // means buzz 3 times, silent 4 times and buzz 3 times. If a duration is 1 second, each character means 0.1 second.
    ```

- Beat

  - Transient haptic. The HIG explains "Transient events are brief and compact, often feeling like taps or impulses. The experience of tapping the Flashlight button on the Home Screen is an example of a transient event."

  - Use combinations of "|" and "_" String to represent a Beat haptic.

    ```swift
    "_|___|____" // means beat twice. If a duration is 1 second, it beats at 0.1 and 0.5 second.
    ```

You can mix two haptic types.

  - If you play two or more events, haptics will happen at the same time for the duration instead of sequencially playing.

  - CAUTION: The length of the string of the each event should be same.

There are two more variable for haptic.

  - intensity: Intensity means the strength of the haptic. The range is 0 to 1.

  - sharpness: You can think of sharpness as a way to abstract a haptic experience into the waveform that produces the corresponding physical sensations. For example, you might use sharpness values to convey an experience that’s soft, rounded, or organic, or one that’s crisp, precise, or mechanical. The range is 0 to 1.

## Example

- To run the example project, clone the repo, and run `pod install` from the Example directory first.

- The iOS Simulator can't simulate a haptic feedback. So a physical device is needed.

## Requirements

- iOS 13+

## Installation

### CocoaPods

CKHaptic is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CKHaptic'
```

## Author

Marcel, chungchung1315@gmail.com

## License

CKHaptic is available under the MIT license. See the LICENSE file for more info.
