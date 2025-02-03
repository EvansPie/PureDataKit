//
//  TestLowPassEqualizerViewController.swift
//  Example_SPM
//
//  Created by Evangelos Pittas on 31/1/25.
//

import PdWrapper
import UIKit

class TestEqualizerViewController: UIViewController {
    
    private var pdAudioController = PdAudioController()
    private let statusLabel = UILabel()
    private let playPauseButton = UIButton(type: .system)
    private let playPauseWavPatch = TestEqualizerPatch()
    private let slider = UISlider()
    private let sliderValueLabel = UILabel()
    
    private var isPlaying = false
    
    deinit {
        pdAudioController?.isActive = false
        pdAudioController = nil
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
        let stackView = UIStackView(arrangedSubviews: [statusLabel, playPauseButton, slider, sliderValueLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        statusLabel.text = "Stopped"
        statusLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        playPauseButton.setTitle(" Play", for: .normal)
        playPauseButton.setImage(UIImage(systemName: isPlaying ? "pause.fill" : "play.fill"), for: .normal)
        playPauseButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        playPauseButton.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0.0
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        sliderValueLabel.text = "Equalizer: \(slider.value)"
        sliderValueLabel.font = UIFont.systemFont(ofSize: 16)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            slider.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1)
        ])
    }
    
    @objc private func togglePlayPause() {
        isPlaying.toggle()
        isPlaying ? playPauseWavPatch.setOn() : playPauseWavPatch.setOff()
        statusLabel.text = isPlaying ? "Playing" : "Stopped"
        let buttonTitle = isPlaying ? " Pause" : " Play"
        playPauseButton.setTitle(buttonTitle, for: .normal)
    }
    
    @objc private func sliderValueChanged() {
        sliderValueLabel.text = "Equalizer: \(String(format: "%.2f", slider.value))"
        playPauseWavPatch.setEqualizer(to: slider.value)
    }
}
