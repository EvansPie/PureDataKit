//
//  TestFrequencyViewController.swift
//  Example_SPM
//
//  Created by Evangelos Pittas on 1/2/25.
//

import PdWrapper
import UIKit

class TestFrequencyViewController: UIViewController {
    
    private var pdAudioController = PdAudioController()
    private let frequencyPatch = TestFrequencyPatch()
    private let slider = UISlider()
    private let sliderValueLabel = UILabel()
    
    private var isPlaying = false
    
    deinit {
        pdAudioController?.isActive = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let pdInit = self.pdAudioController?.configureAmbient(withSampleRate: 44100, numberChannels: 2, mixingEnabled: false)
        self.pdAudioController?.print()
        if pdInit != PdAudioOK {
            print("Failed to initialize audio controller")
        } else {
            print("Audio controller initialized successfully")
        }
        
        pdAudioController?.isActive = true
        
        setupUI()
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [slider, sliderValueLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0.0
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        sliderValueLabel.text = "Frequency: \(slider.value)"
        sliderValueLabel.font = UIFont.systemFont(ofSize: 16)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            slider.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1)
        ])
    }
    
    @objc private func sliderValueChanged() {
        sliderValueLabel.text = "Equalizer: \(String(format: "%.2f", slider.value))"
        frequencyPatch.setFrequency(to: slider.value)
    }
}
