//
//  ViewController.swift
//  Example_SPM
//
//  Created by Evangelos Pittas on 31/1/25.
//

import PdWrapper
import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.spacing = 12
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        
        let tests = [
            ("Test frequency", "Adjust frequency value and listen to changes"),
            ("Test play/pause wav file", "Play or pause a test WAV file"),
            ("Test equalizer", "Apply a low-pass filter to the audio"),
        ]
        
        for (title, subtitle) in tests {
            let cellView = createCell(title: title, subtitle: subtitle) { [weak self] in
                if title == "Test frequency" {
                    self?.navigationController?.pushViewController(TestFrequencyViewController(), animated: true)
                } else if title == "Test play/pause wav file" {
                    self?.navigationController?.pushViewController(PlayPauseViewController(), animated: true)
                } else if title == "Test equalizer" {
                    self?.navigationController?.pushViewController(TestEqualizerViewController(), animated: true)
                }
            }
            mainStackView.addArrangedSubview(cellView)
        }
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    private func createCell(title: String, subtitle: String, onTap: @escaping () -> Void) -> UIView {
        let cellView = UIView()
        cellView.backgroundColor = UIColor.systemGray6
        cellView.layer.cornerRadius = 8
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor = UIColor.systemGray4.cgColor
        cellView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 2
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10),
            
            cellView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        cellView.addGestureRecognizer(tapGesture)
        cellView.isUserInteractionEnabled = true
        
        // Store the closure to execute later
        cellView.tag = cellActions.count
        cellActions.append(onTap)
        
        return cellView
    }

    private var cellActions: [() -> Void] = []

    @objc private func cellTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view, view.tag < cellActions.count else { return }
        let action = cellActions[view.tag]
        action()
    }

}

