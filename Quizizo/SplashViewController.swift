//
//  SplashViewController.swift
//  Quizizo
//
//  Created by MURAD on 3.10.2025.
//

//
//  SplashViewController.swift
//  Quizizo
//
//  Created by MURAD on 3.10.2025.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradientBackground()
        setupOvals()
        setupLogo()

        navigateToAuth()
    }

    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [

            UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 1.0).cgColor,  
            UIColor(red: 0xE2/255.0, green: 0x7B/255.0, blue: 0xF5/255.0, alpha: 1.0).cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 1.5, y: 0.25)
        gradientLayer.endPoint = CGPoint(x: 0.25, y: 1.5)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupOvals() {
        let oval1 = UIImageView(image: UIImage(named: "Oval2"))
        oval1.contentMode = .scaleAspectFit
        oval1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(oval1)

        let oval2 = UIImageView(image: UIImage(named: "Oval1"))
        oval2.contentMode = .scaleAspectFit
        oval2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(oval2)

        NSLayoutConstraint.activate([
            oval1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -43),
            oval1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 231),
            oval1.widthAnchor.constraint(equalToConstant: 200),
            oval1.heightAnchor.constraint(equalToConstant: 200),

            oval2.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            oval2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -40),
            oval2.widthAnchor.constraint(equalToConstant: 200),
            oval2.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setupLogo() {
        let starImageView = UIImageView(image: UIImage(named: "Star"))
        starImageView.contentMode = .scaleAspectFit
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(starImageView)

        NSLayoutConstraint.activate([
            starImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            starImageView.widthAnchor.constraint(equalToConstant: 200),
            starImageView.heightAnchor.constraint(equalToConstant: 275)
        ])
    }

    private func navigateToAuth() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let authVC = AuthViewController()
            authVC.modalTransitionStyle = .crossDissolve
            authVC.modalPresentationStyle = .fullScreen
            self.present(authVC, animated: true, completion: nil)
        }
    }
}
