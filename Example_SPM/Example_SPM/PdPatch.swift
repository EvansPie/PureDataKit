//
//  PureDataPatch.swift
//  Nyfida
//
//  Created by Evangelos Pittas on 30/1/25.
//

import Foundation
import PdWrapper

enum PureDataPatchFile: String {
    case frequencyTest = "frequency_test.pd"
    case equalizerTest = "equalizer_test.pd"
    case playWavTest = "play_wav_test.pd"
}

class PureDataPatch {
    
    init(filename: String) {
        let patch = PdBase.openFile(filename, path: Bundle.main.resourcePath)
        if (patch == nil) {
            fatalError("Failed to load patch")
        }
    }
}

class TestFrequencyPatch: PureDataPatch {
    
    init() {
        super.init(filename: PureDataPatchFile.frequencyTest.rawValue)
    }
    
    func setFrequency(to value: Float) {
        PdBase.send(value, toReceiver: "freq")
    }
}

class TestPlayPauseWavPatch: PureDataPatch {
    
    init() {
        super.init(filename: PureDataPatchFile.playWavTest.rawValue)
    }
    
    func setOn() {
        PdBase.send(1.0, toReceiver: "on")
    }
    
    func setOff() {
        PdBase.send(1.0, toReceiver: "off")
    }
}

class TestEqualizerPatch: PureDataPatch {
    
    init() {
        super.init(filename: PureDataPatchFile.equalizerTest.rawValue)
    }
    
    func setOn() {
        PdBase.send(1.0, toReceiver: "on")
    }
    
    func setOff() {
        PdBase.send(1.0, toReceiver: "off")
    }
    
    func setEqualizer(to value: Float) {
        PdBase.send(value, toReceiver: "eq")
    }
}
