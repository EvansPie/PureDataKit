# PureDataKit

[![Version](https://img.shields.io/cocoapods/v/PureDataKit.svg?style=flat)](https://cocoapods.org/pods/PureDataKit)
[![License](https://img.shields.io/cocoapods/l/PureDataKit.svg?style=flat)](https://github.com/EvansPie/PureDataKit/blob/release/0.1.1/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/PureDataKit.svg?style=flat)](https://cocoapods.org/pods/PureDataKit)

## Overview

**PureDataKit** is a lightweight library that bridges **Pure Data** (PD) audio synthesis and signal processing capabilities to Swift. It exposes the underlying `libpd-ios` library as-is, without providing any additional API itself. This library allows iOS applications to directly interact with the `libpd-ios` library, which is a wrapper for Pure Data (PD), a visual programming language for audio and multimedia.

Please note: **I do not own any copyrights** to the underlying library or Pure Data components. All credit and copyrights belong to the original authors of the [libpd/pd-for-ios](https://github.com/libpd/pd-for-ios) project.

## Example

To run the example project:

1. Clone the repository.
2. Navigate to the **Example** directory.
3. Run `pod install` to install the necessary dependencies.
4. Open the `.xcworkspace` file and build the project in Xcode.

## Requirements

- iOS 12.0 or higher
- Swift 5.0+

## Installation

PureDataKit is available through [CocoaPods](https://cocoapods.org). To install it, add the following line to your Podfile:

```ruby
pod 'PureDataKit'
```
