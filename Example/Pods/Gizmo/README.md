
# Gizmo

Gizmo is a set of common utilities for Swift

[![codebeat badge](https://codebeat.co/badges/4bee383d-c92b-4890-93b0-eaa6ec90faa4)](https://codebeat.co/projects/github-com-hainayanda-gizmo-main)
![build](https://github.com/hainayanda/Gizmo/workflows/build/badge.svg)
![test](https://github.com/hainayanda/Gizmo/workflows/test/badge.svg)
[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen)](https://swift.org/package-manager/)
[![Version](https://img.shields.io/cocoapods/v/Gizmo.svg?style=flat)](https://cocoapods.org/pods/Gizmo)
[![License](https://img.shields.io/cocoapods/l/Gizmo.svg?style=flat)](https://cocoapods.org/pods/Gizmo)
[![Platform](https://img.shields.io/cocoapods/p/Gizmo.svg?style=flat)](https://cocoapods.org/pods/Gizmo)

## Requirements

- Swift 5.5 or higher
- iOS 11.0 or higher
- XCode 13 or higher

## Installation
  
### Cocoapods

Draftsman is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Gizmo', '~> 1.0.0'
```

### Swift Package Manager from XCode

- Add it using XCode menu **File > Swift Package > Add Package Dependency**
- Add **<https://github.com/hainayanda/Gizmo.git>** as Swift Package URL
- Set rules at **version**, with **Up to Next Major** option and put **1.0.0** as its version
- Click next and wait

### Swift Package Manager from Package.swift

Add as your target dependency in ****Package.swift****

```swift
dependencies: [
    .package(url: "https://github.com/hainayanda/Gizmo.git", .upToNextMajor(from: "1.0.0"))
]
```

Use it in your target as `Gizmo`

```swift
.target(
    name: "MyModule",
    dependencies: ["Gizmo"]
)
```

## Author

Nayanda Haberty, hainayanda@outlook.com

## License

Gizmo is available under the MIT license. See the LICENSE file for more info.

## Features

### Common Extensions

- `Array` Extensions
- `Collection` Extensions
- `Data` Extensions
- `Date` Extensions
- `Dictionary` Extensions
- `Int` Extensions
- `String` Extensions
- `TimeInterval` Extensions
- `TimeZone` Extensions

### UIKit Extensions

- `CACornerMask` Extensions
- `CGRect` Extensions
- `CGSize` Extensions
- `UIColor` Extensions
- `UIEdgeInsets` Extensions
- `UIResponder` Extensions

### Helpers

- Closure Helpers
- Statistics Helpers
- Radian Helpers

### Extra

- `GizmoError`
- `UniqueSequence`

***

## Contribute

You know how, just clone and do pull request
