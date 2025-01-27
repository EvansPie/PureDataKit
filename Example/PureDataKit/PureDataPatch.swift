//
//  PureDataPatch.swift
//  PureDataKit
//
//  Created by Evangelos Pittas on 27/1/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import PureDataKit

class PureDataPatch {
    
    init(filename: String) {
        let patch = PdBase.openFile(filename, path: Bundle.main.resourcePath)
        if (patch == nil) {
            print("Failed to load patch")
        }
    }
    
    func onOff(flag: Bool) {
        PdBase.send(flag ? 1.0 : 0.0, toReceiver: "onOff")
    }
    
    func setFrequence(to value: Float) {
        PdBase.send(value, toReceiver: "freq")
    }
    
    func setVolume(to value: Float) {
        PdBase.send(value, toReceiver: "vol")
    }
}
