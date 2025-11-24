//
//  QuizViewController.swift
//  Quizizo
//
//  Created by MURAD on 26.10.2025.
//

import UIKit

class QuizViewController: UIViewController {

    private let questionImageView = UIImageView()
    private let textAnswerView = UITextView()
    private let sendButton = UIButton()
    private let closeButton = UIButton()
    private let timerContainerView = UIView()
    private let timerIconImageView = UIImageView()
    private let timerLabel = UILabel()
    private let questionCardView = UIView()
    private let questionLabel = UILabel()
    private let optionButtons: [UIButton] = (0..<5).map { _ in UIButton() }

    private var questionId: String = ""
    private var correctAnswerIndex: Int = -1
    private var countdown: Int = 59
    private var timer: Timer?
    private var selectedOptionIndex: Int?
    private var questionStartTime: Date?

    private var optionButtonTopConstraints: [NSLayoutConstraint] = []

    var onDismiss: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        addBackgroundOvals()
        setupUI()
        setupConstraints()
        startTimer()
        loadNextQuestion()
    }

    private func setupGradientBackground() {
        view.backgroundColor = .white
    }

    private func setupQuestionImage() {
        view.addSubview(questionImageView)
        questionImageView.translatesAutoresizingMaskIntoConstraints = false
        questionImageView.contentMode = .scaleAspectFit
        questionImageView.layer.cornerRadius = 16
        questionImageView.clipsToBounds = true
        questionImageView.backgroundColor = UIColor(red: 0xF2/255.0, green: 0xE8/255.0, blue: 0xF2/255.0, alpha: 1.0)
        questionImageView.isHidden = true
    }

    private func setupTextAnswer() {
        view.addSubview(textAnswerView)
        view.addSubview(sendButton)

        textAnswerView.translatesAutoresizingMaskIntoConstraints = false
        textAnswerView.layer.cornerRadius = 30
        textAnswerView.layer.borderWidth = 1.5
        textAnswerView.layer.borderColor = UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 0.3).cgColor
        textAnswerView.backgroundColor = .white
        textAnswerView.font = UIFont.systemFont(ofSize: 16)
        textAnswerView.textContainerInset = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        textAnswerView.isHidden = true

        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        sendButton.layer.cornerRadius = 30
        sendButton.isHidden = true
        sendButton.addTarget(self, action: #selector(sendTextAnswer), for: .touchUpInside)

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0xE2/255.0, green: 0x7B/255.0, blue: 0xF5/255.0, alpha: 1.0).cgColor,
            UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 60)
        gradientLayer.cornerRadius = 30

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        sendButton.setBackgroundImage(gradientImage, for: .normal)

        NSLayoutConstraint.activate([
            textAnswerView.topAnchor.constraint(equalTo: questionCardView.bottomAnchor, constant: 24),
            textAnswerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            textAnswerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            textAnswerView.heightAnchor.constraint(equalToConstant: 120),

            sendButton.topAnchor.constraint(equalTo: textAnswerView.bottomAnchor, constant: 16),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            sendButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func addBackgroundOvals() {
        let oval1 = UIImageView(image: UIImage(named: "Oval2")?.withRenderingMode(.alwaysTemplate))
        oval1.contentMode = .scaleAspectFit
        oval1.tintColor = UIColor(red: 0xA8/255.0, green: 0x7D/255.0, blue: 0xF5/255.0, alpha: 1.0)
        oval1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(oval1)
        view.sendSubviewToBack(oval1)

        let oval2 = UIImageView(image: UIImage(named: "Oval1")?.withRenderingMode(.alwaysTemplate))
        oval2.contentMode = .scaleAspectFit
        oval2.tintColor = UIColor(red: 0xA8/255.0, green: 0x7D/255.0, blue: 0xF5/255.0, alpha: 1.0)
        oval2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(oval2)
        view.sendSubviewToBack(oval2)

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

    private func setupUI() {
        setupCloseButton()
        setupTimer()
        setupQuestionCard()
        setupQuestionImage()
        setupTextAnswer()
        setupOptionButtons()
    }

    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.layer.cornerRadius = 25
        closeButton.clipsToBounds = true

        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        closeButton.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0xE2/255.0, green: 0x7B/255.0, blue: 0xF5/255.0, alpha: 1.0).cgColor,
            UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        gradientLayer.cornerRadius = 25

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        closeButton.setBackgroundImage(gradientImage, for: .normal)
    }

    private func setupTimer() {
        view.addSubview(timerContainerView)
        timerContainerView.translatesAutoresizingMaskIntoConstraints = false
        timerContainerView.layer.cornerRadius = 30

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0xE2/255.0, green: 0x7B/255.0, blue: 0xF5/255.0, alpha: 1.0).cgColor,
            UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
        gradientLayer.cornerRadius = 30
        timerContainerView.layer.insertSublayer(gradientLayer, at: 0)

        timerContainerView.addSubview(timerIconImageView)
        timerIconImageView.translatesAutoresizingMaskIntoConstraints = false
        timerIconImageView.image = UIImage(systemName: "clock.fill")
        timerIconImageView.tintColor = .white
        timerIconImageView.contentMode = .scaleAspectFit

        timerContainerView.addSubview(timerLabel)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        timerLabel.textColor = .white
        timerLabel.text = "00:59"
    }

    private func setupQuestionCard() {
        view.addSubview(questionCardView)
        questionCardView.translatesAutoresizingMaskIntoConstraints = false
        questionCardView.backgroundColor = UIColor(red: 0xF2/255.0, green: 0xE8/255.0, blue: 0xF2/255.0, alpha: 1.0)
        questionCardView.layer.cornerRadius = 30

        questionCardView.addSubview(questionLabel)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        questionLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
    }

    private func setupOptionButtons() {
        for (index, button) in optionButtons.enumerated() {
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .white
            button.layer.cornerRadius = 30
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 0.3).cgColor
            button.contentHorizontalAlignment = .left
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0), for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
            button.isHidden = true
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            closeButton.widthAnchor.constraint(equalToConstant: 50),
            closeButton.heightAnchor.constraint(equalToConstant: 50),

            timerContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            timerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerContainerView.heightAnchor.constraint(equalToConstant: 60),
            timerContainerView.widthAnchor.constraint(equalToConstant: 150),

            timerIconImageView.leadingAnchor.constraint(equalTo: timerContainerView.leadingAnchor, constant: 20),
            timerIconImageView.centerYAnchor.constraint(equalTo: timerContainerView.centerYAnchor),
            timerIconImageView.widthAnchor.constraint(equalToConstant: 26),
            timerIconImageView.heightAnchor.constraint(equalToConstant: 26),

            timerLabel.leadingAnchor.constraint(equalTo: timerIconImageView.trailingAnchor, constant: 10),
            timerLabel.centerYAnchor.constraint(equalTo: timerContainerView.centerYAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: timerContainerView.trailingAnchor, constant: -20),

            questionCardView.topAnchor.constraint(equalTo: timerContainerView.bottomAnchor, constant: 50),
            questionCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            questionCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            questionCardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 160),

            questionLabel.topAnchor.constraint(equalTo: questionCardView.topAnchor, constant: 50),
            questionLabel.leadingAnchor.constraint(equalTo: questionCardView.leadingAnchor, constant: 28),
            questionLabel.trailingAnchor.constraint(equalTo: questionCardView.trailingAnchor, constant: -28),
            questionLabel.bottomAnchor.constraint(equalTo: questionCardView.bottomAnchor, constant: -50)
        ])

        updateOptionButtonConstraints()
    }

    private func updateOptionButtonConstraints() {
        NSLayoutConstraint.deactivate(optionButtonTopConstraints)
        optionButtonTopConstraints.removeAll()

        if !questionImageView.isHidden {
            NSLayoutConstraint.activate([
                questionImageView.topAnchor.constraint(equalTo: questionCardView.bottomAnchor, constant: 20),
                questionImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
                questionImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
                questionImageView.heightAnchor.constraint(equalToConstant: 200)
            ])
        }

        for (index, button) in optionButtons.enumerated() {
            guard !button.isHidden else { continue }

            var topConstraint: NSLayoutConstraint

            if index == 0 {
                if !questionImageView.isHidden {
                    topConstraint = button.topAnchor.constraint(equalTo: questionImageView.bottomAnchor, constant: 20)
                } else if !textAnswerView.isHidden {
                    topConstraint = button.topAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 20)
                } else {
                    topConstraint = button.topAnchor.constraint(equalTo: questionCardView.bottomAnchor, constant: 24)
                }
            } else {
                topConstraint = button.topAnchor.constraint(equalTo: optionButtons[index - 1].bottomAnchor, constant: 12)
            }

            optionButtonTopConstraints.append(topConstraint)

            NSLayoutConstraint.activate([
                topConstraint,
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
                button.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
    }

    private func startTimer() {
        countdown = 59
        questionStartTime = Date()
        updateTimerLabel()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.countdown > 0 {
                self.countdown -= 1
                self.updateTimerLabel()
            } else {
                self.timer?.invalidate()
                self.timeExpired()
            }
        }
    }

    private func updateTimerLabel() {
        let minutes = countdown / 60
        let seconds = countdown % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    private func timeExpired() {
        print("⏰ Vaxt bitdi!")
        sendAnswer(selectedIndex: -1)
    }

    func loadNextQuestion() {
        print("📡 Yeni sual yüklənir...")

        timer?.invalidate()
        timer = nil

        APIManager.shared.fetchNextQuestion { [weak self] response in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let response = response {
                    self.processAPIQuestion(data: response)
                } else {
                    print("❌ API error, loading demo question")
                    self.loadDemoQuestion()
                }
            }
        }
    }

    private func processAPIQuestion(data: [String: Any]) {
        print("✅ API cavab gəldi:", data)

        resetUI()

        guard let questionData = data["data"] as? [String: Any] else {
            print("❌ 'data' key tapılmadı")
            loadDemoQuestion()
            return
        }

        if let id = questionData["id"] as? String {
            questionId = id
            print("📝 Question ID:", questionId)
        }

        if let qText = questionData["questionText"] as? String, qText != "<null>" {
            questionLabel.text = qText
        } else {
            questionLabel.text = "Which of the following options is correct?"
        }

        let type = questionData["type"] as? String ?? "MULTIPLE_CHOICE"
        print("📋 Question Type:", type)

        if let imageUrl = questionData["imageUrl"] as? String, !imageUrl.isEmpty {
            let fullImageUrl = "https://api.quizizo.com\(imageUrl)"
            print("🖼️ Image URL:", fullImageUrl)
            questionImageView.isHidden = false
            loadImage(from: fullImageUrl)
        }

        if let options = questionData["options"] as? [[String: Any]] {
            showOptionsFromAPI(options)


            if let correctIndex = options.firstIndex(where: { ($0["isCorrect"] as? Bool) == true }) {
                self.correctAnswerIndex = correctIndex
                print("✅ Düzgün cavab index (options-dan): \(correctIndex)")
            } else {

                self.correctAnswerIndex = -1
                print("⚠️ isCorrect key tapılmadı, correctIndex = -1")
            }
        }

        updateOptionButtonConstraints()
        view.setNeedsLayout()
        view.layoutIfNeeded()

        timer?.invalidate()
        startTimer()
    }

    private func showOptionsFromAPI(_ options: [[String: Any]]) {
        print("🔢 Options sayı:", options.count)

        for (i, btn) in optionButtons.enumerated() {
            if i < options.count {
                let option = options[i]

                var optionText = ""
                if let text = option["text"] as? String {
                    optionText = text
                }

                btn.isHidden = false
                btn.setTitle(optionText, for: .normal)
                btn.backgroundColor = .white
                btn.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0), for: .normal)
                btn.layer.borderColor = UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 0.3).cgColor
            } else {
                btn.isHidden = true
            }
        }
    }

    private func resetUI() {
        optionButtons.forEach {
            $0.isHidden = true
            $0.backgroundColor = .white
            $0.isUserInteractionEnabled = true
        }
        textAnswerView.isHidden = true
        textAnswerView.text = ""
        sendButton.isHidden = true
        questionImageView.isHidden = true
        questionImageView.image = nil
        questionImageView.constraints.forEach { $0.isActive = false }
        selectedOptionIndex = nil
    }

    private func loadDemoQuestion() {
        let demoData: [String: Any] = [
            "status": "success",
            "data": [
                "id": "demo-123",
                "questionText": "Which of these landmarks is located in Rome?",
                "type": "MULTIPLE_CHOICE",
                "options": [
                    ["text": "A) Eiffel Tower"],
                    ["text": "B) Colosseum", "isCorrect": true],
                    ["text": "C) Big Ben"],
                    ["text": "D) Statue of Liberty"]
                ]
            ]
        ]
        processAPIQuestion(data: demoData)
    }

    private func loadImage(from urlString: String) {
        print("🖼️ Loading image from: \(urlString)")
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            return
        }

        questionImageView.backgroundColor = UIColor(red: 0xF2/255.0, green: 0xE8/255.0, blue: 0xF2/255.0, alpha: 1.0)

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("❌ Image load error: \(error)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("❌ Could not create image from data")
                return
            }

            DispatchQueue.main.async {
                print("✅ Image loaded successfully")
                self?.questionImageView.image = image
                self?.questionImageView.backgroundColor = .clear
            }
        }.resume()
    }

    private func sendAnswer(selectedIndex: Int) {
        guard !questionId.isEmpty else {
            print("❌ Question ID yoxdur")
            loadNextQuestion()
            return
        }

        let duration = Int(Date().timeIntervalSince(questionStartTime ?? Date()))

        print("📤 Cavab göndərilir:")
        print("  - Question ID: \(questionId)")
        print("  - Selected Index: \(selectedIndex)")
        print("  - Duration: \(duration)s")

        let selectedButton = selectedIndex >= 0 ? optionButtons[selectedIndex] : nil

        APIManager.shared.sendAnswer(questionId: questionId, selectedIndex: selectedIndex, duration: duration) { [weak self] isCorrect, correctIndexFromBackend in
            guard let self = self else { return }

            DispatchQueue.main.async {
                // ✅ Backend correctIndex göndərdisə, onu MÜTLƏQ saxla
                if let correctIndexFromBackend = correctIndexFromBackend {
                    self.correctAnswerIndex = correctIndexFromBackend
                    print("✅ Backend-dən correctIndex alındı və saxlanıldı: \(correctIndexFromBackend)")
                } else {
                    print("⚠️ Backend correctIndex göndərmədi!")
                }

                if isCorrect {

                    print("✅ Düzgün cavab!")
                    if let button = selectedButton {
                        button.backgroundColor = .systemGreen
                        button.setTitleColor(.white, for: .normal)
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.loadNextQuestion()
                    }
                } else {

                    print("❌ Səhv cavab!")
                    print("💡 Düzgün cavab index: \(self.correctAnswerIndex)")

                    if let button = selectedButton {
                        button.backgroundColor = .systemRed
                        button.setTitleColor(.white, for: .normal)
                    }


                    self.showWrongAnswerModal()
                }
            }
        }
    }

    private func showWrongAnswerModal() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let modal = WrongAnswerModalViewController()
            modal.modalPresentationStyle = .overFullScreen
            modal.modalTransitionStyle = .crossDissolve

            modal.onContinue = { [weak self] in
                guard let self = self else { return }
                print("👀 Cevabı göstər")


                self.optionButtons.forEach {
                    $0.backgroundColor = .white
                    $0.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0), for: .normal)
                    $0.layer.borderColor = UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 0.3).cgColor
                }

                
                if self.correctAnswerIndex >= 0 && self.correctAnswerIndex < self.optionButtons.count {
                    let correctButton = self.optionButtons[self.correctAnswerIndex]
                    correctButton.backgroundColor = .systemGreen
                    correctButton.setTitleColor(.white, for: .normal)
                    correctButton.layer.borderColor = UIColor.systemGreen.cgColor

                    UIView.animate(withDuration: 0.2, animations: {
                        correctButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    }) { _ in
                        UIView.animate(withDuration: 0.2) {
                            correctButton.transform = .identity
                        }
                    }
                } else {
                    print("⚠️ correctAnswerIndex mövcud deyil, düzgün cavab göstərilə bilməz")
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.loadNextQuestion()
                }
            }

            modal.onPlayAgain = { [weak self] in
                print("▶️ Növbəti suala keç")
                self?.loadNextQuestion()
            }

            modal.onQuit = { [weak self] in
                print("🚪 Oyundan çıx")
                self?.dismiss(animated: true)
            }

            self.present(modal, animated: true)
        }
    }

    @objc private func sendTextAnswer() {
        let answerText = textAnswerView.text ?? ""
        print("📤 Open answer:", answerText)

        sendButton.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.sendButton.alpha = 1.0
            self.loadNextQuestion()
        }
    }

    @objc private func optionButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        selectOption(at: index)

        timer?.invalidate()
        optionButtons.forEach { $0.isUserInteractionEnabled = false }

        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                sender.transform = .identity
            }

            self.sendAnswer(selectedIndex: index)
        }
    }

    private func selectOption(at index: Int) {
        for button in optionButtons {
            button.backgroundColor = .white
            button.layer.borderColor = UIColor(red: 0x7C/255.0, green: 0x5E/255.0, blue: 0xF1/255.0, alpha: 0.3).cgColor
            button.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0), for: .normal)
        }

        let selectedButton = optionButtons[index]
        selectedButton.backgroundColor = UIColor(red: 0xA8/255.0, green: 0x7D/255.0, blue: 0xF5/255.0, alpha: 1.0)
        selectedButton.layer.borderColor = UIColor(red: 0xA8/255.0, green: 0x7D/255.0, blue: 0xF5/255.0, alpha: 1.0).cgColor
        selectedButton.setTitleColor(.white, for: .normal)
    }

    @objc private func closeButtonTapped() {
        timer?.invalidate()
        dismiss(animated: true) { [weak self] in
            self?.onDismiss?()
        }
    }

    deinit {
        timer?.invalidate()
    }
}
