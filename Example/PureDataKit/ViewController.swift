//
//  ViewController.swift
//  PureDataKit
//
//  Created by Evangelos Pittas on 01/27/2025.
//  Copyright (c) 2025 Evangelos Pittas. All rights reserved.
//

import PureDataKit
import UIKit

class ViewController: UIViewController {
    
    let pdAudioController = PdAudioController()
    let pdPatch = PureDataPatch(filename: "freq_vol_test.pd")
    let frequencySlider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//         Initialize the PdAudioController
        let pdInit = self.pdAudioController!.configureAmbient(withSampleRate: 44100, numberChannels: 2, mixingEnabled: true)
        
        if pdInit != PdAudioOK {
            print("Failed to initialize")
        }
        
        self.pdAudioController!.isActive = true
        
        // Configure the UI components
        setupSliders()
    }
    
    private func setupSliders() {
        // Configure frequency slider
        configureSlider(frequencySlider, minValue: 0.0, maxValue: 1.0, defaultValue: 0.5)
        frequencySlider.addTarget(self, action: #selector(frequencySliderChanged(_:)), for: .valueChanged)
        
        // Add sliders to the view
        frequencySlider.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(frequencySlider)
        
        // Set constraints for sliders
        NSLayoutConstraint.activate([
            // Frequency slider constraints
            frequencySlider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            frequencySlider.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            frequencySlider.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
        ])
    }
    
    private func configureSlider(_ slider: UISlider, minValue: Float, maxValue: Float, defaultValue: Float) {
        slider.minimumValue = minValue
        slider.maximumValue = maxValue
        slider.value = defaultValue
    }
    
    @objc private func onOffSwitchToggled(_ sender: UISwitch) {
        self.pdPatch.onOff(flag: sender.isOn)
    }
    
    @objc private func frequencySliderChanged(_ sender: UISlider) {
        let frequencyValue = sender.value
        print("Frequency slider value: \(frequencyValue)")
        self.pdPatch.setFrequence(to: frequencyValue) // Assuming PdPatch has a `setFrequency` method
    }
    
    @objc private func volumeSliderChanged(_ sender: UISlider) {
        let volumeValue = sender.value
        print("Volume slider value: \(volumeValue)")
        self.pdPatch.setVolume(to: volumeValue) // Assuming PdPatch has a `setVolume` method
    }
}
