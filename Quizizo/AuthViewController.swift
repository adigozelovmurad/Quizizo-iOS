//
//  AuthViewController.swift
//  Quizizo
//
//  Created by MURAD on 3.10.2025.


import UIKit
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        addBackgroundOvals()
        setupUI()


//        // TEST Button
//        let testButton = UIButton(type: .system)
//        testButton.setTitle("Test Keychain", for: .normal)
//        testButton.setTitleColor(.white, for: .normal)
//        testButton.backgroundColor = .systemBlue
//        testButton.layer.cornerRadius = 10
//        testButton.translatesAutoresizingMaskIntoConstraints = false
//        testButton.addTarget(self, action: #selector(testKeychain), for: .touchUpInside)
//        view.addSubview(testButton)
//
//        NSLayoutConstraint.activate([
//            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            testButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            testButton.widthAnchor.constraint(equalToConstant: 180),
//            testButton.heightAnchor.constraint(equalToConstant: 50)
//        ])



        KeychainManager.save(key: "testToken", value: "hello_keychain")
            if let value = KeychainManager.read(key: "testToken") {
                print("✅ Keychain işləyir, oxunan dəyər: \(value)")
            } else {
                print("❌ Keychain işləməyib")
            }
        
    }

    // MARK: - Gradient Background
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 1.0).cgColor,
            UIColor(red: 0xE2/255.0, green: 0x7B/255.0, blue: 0xF5/255.0, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: - Ovals
    private func addBackgroundOvals() {
        let oval1 = UIImageView(image: UIImage(named: "Oval2"))
        oval1.contentMode = .scaleAspectFit
        oval1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(oval1)

        let oval2 = UIImageView(image: UIImage(named: "Oval1"))
        oval2.contentMode = .scaleAspectFit
        oval2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(oval2)

        NSLayoutConstraint.activate([
            oval1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 111),
            oval1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 231),
            oval1.widthAnchor.constraint(equalToConstant: 200),
            oval1.heightAnchor.constraint(equalToConstant: 200),

            oval2.topAnchor.constraint(equalTo: view.topAnchor, constant: 284),
            oval2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -71),
            oval2.widthAnchor.constraint(equalToConstant: 200),
            oval2.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func sendTokenToBackend(idToken: String, provider: String) {
        let url = URL(string: "https://api.quizizo.com/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "provider": provider,
            "idToken": idToken,
            "country": "AZ"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Backend error:", error)
                return
            }

            guard let data = data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data) {
                print("✅ Backend response:", json)
            }
        }.resume()
    }

    // MARK: - UI Setup
    private func setupUI() {
        let logoImageView = UIImageView(image: UIImage(named: "Star"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)

        let googleButton = createButton(
            title: "Continue with Google",
            titleColor: .black,
            backgroundColor: .white,
            iconName: "google_logo"
        )
        googleButton.addTarget(self, action: #selector(googleTapped), for: .touchUpInside)

        let appleButton = createButton(
            title: "Continue with Apple",
            titleColor: .black,
            backgroundColor: .white,
            iconName: "apple_logo"
        )
        appleButton.addTarget(self, action: #selector(appleTapped), for: .touchUpInside)

        view.addSubview(googleButton)
        view.addSubview(appleButton)

        let privacyLabel = UILabel()
        privacyLabel.numberOfLines = 2
        privacyLabel.textAlignment = .center
        privacyLabel.translatesAutoresizingMaskIntoConstraints = false

        let attributedText = NSMutableAttributedString(
            string: "Read the Privacy & Policy and User & Terms\nbefore using IQity app",
            attributes: [
                .font: UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.white.withAlphaComponent(0.8)
            ]
        )
        if let range1 = attributedText.string.range(of: "Privacy & Policy") {
            attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(range1, in: attributedText.string))
        }
        if let range2 = attributedText.string.range(of: "User & Terms") {
            attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(range2, in: attributedText.string))
        }
        privacyLabel.attributedText = attributedText
        view.addSubview(privacyLabel)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 94),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 275),

            googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleButton.bottomAnchor.constraint(equalTo: appleButton.topAnchor, constant: -20),
            googleButton.widthAnchor.constraint(equalToConstant: 315),
            googleButton.heightAnchor.constraint(equalToConstant: 65),

            appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleButton.bottomAnchor.constraint(equalTo: privacyLabel.topAnchor, constant: -65),
            appleButton.widthAnchor.constraint(equalToConstant: 315),
            appleButton.heightAnchor.constraint(equalToConstant: 65),

            privacyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            privacyLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            privacyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            privacyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }

    // MARK: - Button Factory
    private func createButton(title: String, titleColor: UIColor, backgroundColor: UIColor, iconName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false

        let icon = UIImageView(image: UIImage(named: iconName))
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = title
        label.textColor = titleColor
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.axis = .horizontal
        stack.spacing = 18
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        button.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 27)
        ])

        return button
    }

    // MARK: - Button Actions
    @objc private func googleTapped() {
        print("Google button tapped")
        #if canImport(GoogleSignIn)
        let clientID = "922139816361-9elohg4r6tb7l4rfkdqrq3lmcgv58gp0.apps.googleusercontent.com"
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            if let error = error {
                print("❌ Google Sign-In failed:", error.localizedDescription)
                return
            }
            guard let user = result?.user else { return }

            // Tokenu Keychain-ə saxla
            if let idToken = user.idToken?.tokenString {
                KeychainManager.save(key: "authToken", value: idToken)
                self?.sendTokenToBackend(idToken: idToken, provider: "google")
            }

            // HOME EKRANINA KEÇİD
            self?.navigateToHome(
                name: user.profile?.name ?? "User",
                email: user.profile?.email ?? "",
                photoURL: user.profile?.imageURL(withDimension: 200)?.absoluteString
            )
        }
        #endif
    }

    @objc private func appleTapped() {
        print("🍎 Apple button tapped (Demo mode)")
        let fakeToken = "demo_apple_token_12345"
        KeychainManager.save(key: "authToken", value: fakeToken)
        sendTokenToBackend(idToken: fakeToken, provider: "apple")

        // HOME EKRANINA KEÇİD (Demo üçün)
        navigateToHome(name: "Demo User", email: "demo@apple.com", photoURL: nil)
    }

    @objc private func testKeychain() {
        print("🔹 Test düyməsi basıldı")

        // YAZ
        KeychainManager.save(key: "testToken", value: "hello_keychain")

        // OXU
        if let value = KeychainManager.read(key: "testToken") {
            print("✅ Keychain işləyir, oxunan dəyər: \(value)")
        } else {
            print("❌ Keychain işləməyib")
        }

        // SİL
        KeychainManager.delete(key: "testToken")
        if KeychainManager.read(key: "testToken") == nil {
            print("✅ Token uğurla silindi")
        } else {
            print("❌ Token hələ də qalır")
        }
    }


    // MARK: - Navigation
    private func navigateToHome(name: String, email: String, photoURL: String?) {
        let homeVC = HomeViewController()
        homeVC.userName = name
        homeVC.userEmail = email
        homeVC.profileImageURL = photoURL
        homeVC.userXP = 3900

        homeVC.modalPresentationStyle = .fullScreen
        homeVC.modalTransitionStyle = .crossDissolve

        DispatchQueue.main.async {
            if self.presentedViewController == nil {
                self.present(homeVC, animated: true, completion: nil)
            } else {
                self.presentedViewController?.dismiss(animated: true) {
                    self.present(homeVC, animated: true, completion: nil)
                }
            }
        }
    }
}
