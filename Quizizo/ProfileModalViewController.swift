//
//  ProfileModalViewController.swift
//  Quizizo
//
//  Created by MURAD on 8.11.2025.
//

import UIKit

class ProfileModalViewController: UIViewController {

    var userName: String = "User"
    var userEmail: String = ""
    var profileImageURL: String?
    var userXP: Int = 0

    var onLogout: (() -> Void)?

    private let containerView = UIView()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let xpLabel = UILabel()
    private let settingsButton = UIButton()
    private let logoutButton = UIButton()
    private let closeButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)


        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)


        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 1.0).cgColor,
            UIColor(red: 0xE2/255.0, green: 0x7B/255.0, blue: 0xF5/255.0, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 340, height: 480)
        gradientLayer.cornerRadius = 30
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        containerView.layer.cornerRadius = 30


        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        closeButton.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        containerView.addSubview(closeButton)


        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        profileImageView.layer.borderWidth = 4
        profileImageView.layer.borderColor = UIColor.white.cgColor
        containerView.addSubview(profileImageView)


        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = userName
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        containerView.addSubview(nameLabel)


        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = userEmail
        emailLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        emailLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        emailLabel.textAlignment = .center
        containerView.addSubview(emailLabel)


        xpLabel.translatesAutoresizingMaskIntoConstraints = false
        xpLabel.text = "⭐️ \(userXP) XP"
        xpLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        xpLabel.textColor = .white
        xpLabel.textAlignment = .center
        xpLabel.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        xpLabel.layer.cornerRadius = 20
        xpLabel.clipsToBounds = true
        containerView.addSubview(xpLabel)


        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.setTitle("⚙️  Settings", for: .normal)
        settingsButton.setTitleColor(UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 1.0), for: .normal)
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        settingsButton.backgroundColor = .white
        settingsButton.layer.cornerRadius = 16
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        containerView.addSubview(settingsButton)


        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("🚪  Log Out", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        logoutButton.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        logoutButton.layer.cornerRadius = 16
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        containerView.addSubview(logoutButton)


        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 340),
            containerView.heightAnchor.constraint(equalToConstant: 480),

            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),

            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 60),
            profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),

            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            xpLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 16),
            xpLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            xpLabel.widthAnchor.constraint(equalToConstant: 120),
            xpLabel.heightAnchor.constraint(equalToConstant: 40),

            settingsButton.topAnchor.constraint(equalTo: xpLabel.bottomAnchor, constant: 40),
            settingsButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            settingsButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            settingsButton.heightAnchor.constraint(equalToConstant: 56),

            logoutButton.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: 16),
            logoutButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            logoutButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            logoutButton.heightAnchor.constraint(equalToConstant: 56)
        ])


        loadProfileData()


        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
    }

    private func loadProfileData() {
        nameLabel.text = userName
        emailLabel.text = userEmail
        xpLabel.text = "⭐️ \(userXP) XP"

        if let imageURL = profileImageURL, let url = URL(string: imageURL) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.profileImageView.image = image
                    }
                }
            }.resume()
        } else {

            let initials = String(userName.prefix(2)).uppercased()
            profileImageView.image = createInitialsImage(initials: initials)
        }
    }

    private func createInitialsImage(initials: String) -> UIImage {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.white.withAlphaComponent(0.3).cgColor)
        context?.fill(CGRect(origin: .zero, size: size))

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 40, weight: .bold),
            .foregroundColor: UIColor.white
        ]

        let text = initials as NSString
        let textSize = text.size(withAttributes: attributes)
        let textRect = CGRect(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        text.draw(in: textRect, withAttributes: attributes)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image ?? UIImage()
    }

    @objc private func settingsTapped() {
        print("⚙️ Settings tapped")
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .formSheet
        settingsVC.modalTransitionStyle = .crossDissolve
        present(settingsVC, animated: true)
    }

    @objc private func logoutTapped() {
        print("🚪 Logout tapped")

        let alert = UIAlertController(
            title: "Log Out",
            message: "Are you sure you want to log out?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })

        present(alert, animated: true)
    }

    private func performLogout() {
        // Token sil
        KeychainManager.delete(key: "authToken")

        print("✅ Token deleted, redirecting to auth...")

        // Animation ilə bağlan
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.containerView.alpha = 0
        }) { _ in
            self.dismiss(animated: false) {
                // Callback ilə logout et
                self.onLogout?()
            }
        }
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func backgroundTapped() {
        dismiss(animated: true)
    }
}
