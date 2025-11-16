//
//  WrongAnswerModalViewController.swift
//  Quizizo
//
//  Created by MURAD on 13.11.2025.
//


import UIKit

class WrongAnswerModalViewController: UIViewController {

    var onContinue: (() -> Void)?
    var onPlayAgain: (() -> Void)?
    var onQuit: (() -> Void)?

    private var countdownSeconds = 5
    private var countdownTimer: Timer?

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let countdownLabel = UILabel()
    private let quitButton = UIButton()
    private let playAgainButton = UIButton()
    private let continueButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startCountdown()
    }

    private func setupUI() {
        // Semi-transparent background
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        // Container
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 24
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        // Title Label
        titleLabel.text = "Sıradaki soruya geçiliyor"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        // Countdown Label
        countdownLabel.text = "5s"
        countdownLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        countdownLabel.textColor = UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 1.0)
        countdownLabel.textAlignment = .center
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(countdownLabel)

        // Oyundan Çık Button
        quitButton.setTitle("Oyundan Çık", for: .normal)
        quitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        quitButton.setTitleColor(UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 1.0), for: .normal)
        quitButton.backgroundColor = .white
        quitButton.layer.cornerRadius = 20
        quitButton.layer.borderWidth = 2
        quitButton.layer.borderColor = UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 0.3).cgColor
        quitButton.translatesAutoresizingMaskIntoConstraints = false
        quitButton.addTarget(self, action: #selector(quitTapped), for: .touchUpInside)
        containerView.addSubview(quitButton)

        // Devam Et Button
        playAgainButton.setTitle("Devam et", for: .normal)
        playAgainButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        playAgainButton.setTitleColor(.white, for: .normal)
        playAgainButton.layer.cornerRadius = 20
        playAgainButton.translatesAutoresizingMaskIntoConstraints = false
        playAgainButton.addTarget(self, action: #selector(playAgainTapped), for: .touchUpInside)

        // Gradient background for Devam Et button
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0xE2/255.0, green: 0x7B/255.0, blue: 0xF5/255.0, alpha: 1.0).cgColor,
            UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 280, height: 56)
        gradientLayer.cornerRadius = 20

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        playAgainButton.setBackgroundImage(gradientImage, for: .normal)

        containerView.addSubview(playAgainButton)

        // Cevabı gör Button
        continueButton.setTitle("Cevabı gör", for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.backgroundColor = UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 1.0)
        continueButton.layer.cornerRadius = 20
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        containerView.addSubview(continueButton)

        // Constraints
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 340),
            containerView.heightAnchor.constraint(equalToConstant: 380),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),

            countdownLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            countdownLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),

            quitButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            quitButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            quitButton.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -12),
            quitButton.heightAnchor.constraint(equalToConstant: 56),

            continueButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            continueButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            continueButton.bottomAnchor.constraint(equalTo: playAgainButton.topAnchor, constant: -12),
            continueButton.heightAnchor.constraint(equalToConstant: 56),

            playAgainButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            playAgainButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            playAgainButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            playAgainButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func startCountdown() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.countdownSeconds > 0 {
                self.countdownSeconds -= 1
                self.countdownLabel.text = "\(self.countdownSeconds)s"
            } else {
                self.countdownTimer?.invalidate()
                self.autoPlayAgain()
            }
        }
    }

    private func autoPlayAgain() {
        dismiss(animated: true) { [weak self] in
            self?.onPlayAgain?()
        }
    }

    @objc private func quitTapped() {
        print("🚪 Oyundan çık")
        countdownTimer?.invalidate()
        dismiss(animated: true) { [weak self] in
            self?.onQuit?()
        }
    }

    @objc private func continueTapped() {
        print("👀 Cevabı gör")
        countdownTimer?.invalidate()
        dismiss(animated: true) { [weak self] in
            self?.onContinue?()
        }
    }

    @objc private func playAgainTapped() {
        print("▶️ Devam et")
        countdownTimer?.invalidate()
        dismiss(animated: true) { [weak self] in
            self?.onPlayAgain?()
        }
    }

    deinit {
        countdownTimer?.invalidate()
    }
}
