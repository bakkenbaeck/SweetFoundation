# SweetFoundation

[![Version](https://img.shields.io/cocoapods/v/SweetFoundation.svg?style=flat)](https://cocoapods.org/pods/SweetFoundation)
[![License](https://img.shields.io/cocoapods/l/SweetFoundation.svg?style=flat)](https://cocoapods.org/pods/SweetFoundation)
[![Platform](https://img.shields.io/cocoapods/p/SweetFoundation.svg?style=flat)](https://cocoapods.org/pods/SweetFoundation)

## Usage
### Math helpers
Simple helpers to convert degrees to radians and vice-versa.

```swift
Math.degreesToRadians()
Math.radiansToDegrees()
```
### DispatchQueue helpers
Dispatch async after using seconds (`Double`), instead of dealing with `DispatchTime`.

```swift
DispatchQueue.asyncAfter(seconds: 1.5) { }
```
### Serialisation
We include a simple JSON to String serialiser that guarantees the order of dictionary keys to be alphabetical. This is essential when signing or hashing payloads.

```swift
let hashableString = OrderedSerializer.string(from: jsonPayload)
```

### String range conversion.
To avoid having to do constant casts to `String` or `NSString` to get the range type you need, we've added two simple methods to convert between them:g

```swift
// from Range<String.Index> to NSRange
let range = string.range(of: "substring")
let nsRange = range.nsRange(on: string)

// from NSRange to Range<String.Index>
let range = nsRange.range(on: string as NSString)
```

### Base64 with or without padding
Sometimes you need to deal with base64 strings without the padding.

```swift
// Generate base64 string without padding from a Data structure.
let noPadding = "This is a test string".data(using: .utf8)!.base64EncodedStringWithoutPadding()

// sometimes you want the padding back.
noPadding.paddedForBase64
```

## Installation

**SweetFoundation** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SweetFoundation'
```

**SweetFoundation** is also available through [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Cartfile:

```ruby
github "SweetOrg/SweetFoundation"
```

## License

**SweetFoundation** is available under the MIT license. See the LICENSE file for more info.

## Author

Bakken & Bæck, [@SweetOrg](https://twitter.com/SweetOrg)
