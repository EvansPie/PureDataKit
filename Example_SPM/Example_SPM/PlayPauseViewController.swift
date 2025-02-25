//
//  PlayPauseViewController.swift
//  Example_SPM
//
//  Created by Evangelos Pittas on 31/1/25.
//

import PdWrapper
import UIKit

class PlayPauseViewController: UIViewController {
    
    private let pdAudioController = PdAudioController()
    private let statusLabel = UILabel()
    private let playPauseButton = UIButton(type: .system)
    private let playPauseWavPatch = TestPlayPauseWavPatch()
    
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
        let stackView = UIStackView(arrangedSubviews: [statusLabel, playPauseButton])
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
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func togglePlayPause() {
        isPlaying.toggle()
        isPlaying ? playPauseWavPatch.setOn() : playPauseWavPatch.setOff()
        statusLabel.text = isPlaying ? "Playing" : "Stopped"
        let buttonTitle = isPlaying ? " Pause" : " Play"
        playPauseButton.setTitle(buttonTitle, for: .normal)
    }
}

