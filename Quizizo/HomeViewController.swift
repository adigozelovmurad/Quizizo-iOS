//
//  HomeViewController.swift
//  Quizizo
//
//  Created by MURAD on 7.10.2025.
//
import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    private let nameLabel = UILabel()
    private let xpContainerView = UIView()
    private let xpIconImageView = UIImageView()
    private let xpLabel = UILabel()
    private let profileImageView = UIImageView()
    private let statsCardView = UIView()
    private let averageTimeCard = UIView()
    private let totalTimeCard = UIView()
    private let performanceCardView = UIView()
    private let playButton = UIButton()
    private let bottomNavView = UIView()

    // User Data
    var userName: String = "Madina Omar"
    var userEmail: String = ""
    var userXP: Int = 3900
    var profileImageURL: String?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        addBackgroundOvals()
        setupUI()
        setupConstraints()
        loadUserData()
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

    // MARK: - Setup UI
    private func setupUI() {
        setupHeader()
        setupStatsCard()
        setupTimeCards()
        setupPerformanceCard()
        setupPlayButton()
        setupBottomNavigation()
    }

    private func setupHeader() {
        // Name Label
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.text = userName

        // XP Container
        view.addSubview(xpContainerView)
        xpContainerView.translatesAutoresizingMaskIntoConstraints = false


        // XP Icon
        xpContainerView.addSubview(xpIconImageView)
        xpIconImageView.translatesAutoresizingMaskIntoConstraints = false
        xpIconImageView.image = UIImage(named: "Xp")
        xpIconImageView.contentMode = .scaleAspectFit

        // XP Label
        xpContainerView.addSubview(xpLabel)
        xpLabel.translatesAutoresizingMaskIntoConstraints = false
        xpLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        xpLabel.textColor = .white
        xpLabel.text = "XP \(userXP)"

        // Profile Image
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 27
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = UIColor(red: 0.75, green: 0.6, blue: 0.95, alpha: 1.0)
    }

    private func setupStatsCard() {
        view.addSubview(statsCardView)
        statsCardView.translatesAutoresizingMaskIntoConstraints = false
        statsCardView.backgroundColor = .white
        statsCardView.layer.cornerRadius = 28

        let worldStack = createStatsColumn(imageName: "World", title: "WORLD RANK", value: "#1,438")
        let divider1 = createDivider()
        let scoreStack = createStatsColumn(imageName: "Score", title: "SCORE", value: "590")
        let divider2 = createDivider()
        let localStack = createStatsColumn(imageName: "Flag", title: "LOCAL RANK", value: "#56")

        statsCardView.addSubview(worldStack)
        statsCardView.addSubview(divider1)
        statsCardView.addSubview(scoreStack)
        statsCardView.addSubview(divider2)
        statsCardView.addSubview(localStack)

        NSLayoutConstraint.activate([
            worldStack.leadingAnchor.constraint(equalTo: statsCardView.leadingAnchor, constant: 12),
            worldStack.topAnchor.constraint(equalTo: statsCardView.topAnchor, constant: 30),
            worldStack.bottomAnchor.constraint(equalTo: statsCardView.bottomAnchor, constant: -32),
            worldStack.widthAnchor.constraint(equalTo: statsCardView.widthAnchor, multiplier: 0.28),

            divider1.leadingAnchor.constraint(equalTo: worldStack.trailingAnchor, constant: 16),
            divider1.topAnchor.constraint(equalTo: statsCardView.topAnchor, constant: 16),
            divider1.bottomAnchor.constraint(equalTo: statsCardView.bottomAnchor, constant: -32),
            divider1.widthAnchor.constraint(equalToConstant: 1),

            scoreStack.centerXAnchor.constraint(equalTo: statsCardView.centerXAnchor),
            scoreStack.topAnchor.constraint(equalTo: statsCardView.topAnchor, constant: 30),
            scoreStack.bottomAnchor.constraint(equalTo: statsCardView.bottomAnchor, constant: -32),

            divider2.leadingAnchor.constraint(equalTo: scoreStack.trailingAnchor, constant: 16),
            divider2.topAnchor.constraint(equalTo: statsCardView.topAnchor, constant: 16),
            divider2.bottomAnchor.constraint(equalTo: statsCardView.bottomAnchor, constant: -32),
            divider2.widthAnchor.constraint(equalToConstant: 1),

            localStack.trailingAnchor.constraint(equalTo: statsCardView.trailingAnchor, constant: -12),
            localStack.topAnchor.constraint(equalTo: statsCardView.topAnchor, constant: 30),
            localStack.bottomAnchor.constraint(equalTo: statsCardView.bottomAnchor, constant: -32),
            localStack.widthAnchor.constraint(equalTo: statsCardView.widthAnchor, multiplier: 0.28)
        ])
    }

    private func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.95, alpha: 1.0)
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }

    private func createStatsColumn(imageName: String, title: String, value: String) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: imageName)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 28.5).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        titleLabel.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.85, alpha: 1.0)
        titleLabel.textAlignment = .center

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        valueLabel.textColor = UIColor(red: 0.55, green: 0.4, blue: 0.85, alpha: 1.0)
        valueLabel.textAlignment = .center

        stack.addArrangedSubview(iconImageView)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(valueLabel)

        return stack
    }

    private func setupTimeCards() {
        view.addSubview(averageTimeCard)
        averageTimeCard.translatesAutoresizingMaskIntoConstraints = false
        averageTimeCard.backgroundColor = UIColor(red: 0.92, green: 0.88, blue: 0.98, alpha: 1.0)
        averageTimeCard.layer.cornerRadius = 20




        let avgIcon = UIImageView()
        avgIcon.image = UIImage(named: "Total_time")
        avgIcon.contentMode = .scaleAspectFit

        let avgValue = UILabel()
        avgValue.text = "9.39"
        avgValue.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        avgValue.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)

        let avgTitle = UILabel()
        avgTitle.text = "Average time"
        avgTitle.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        avgTitle.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)

        averageTimeCard.addSubview(avgIcon)
        averageTimeCard.addSubview(avgValue)
        averageTimeCard.addSubview(avgTitle)

        avgIcon.translatesAutoresizingMaskIntoConstraints = false
        avgValue.translatesAutoresizingMaskIntoConstraints = false
        avgTitle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avgIcon.topAnchor.constraint(equalTo: averageTimeCard.topAnchor, constant: 24),
            avgIcon.trailingAnchor.constraint(equalTo: averageTimeCard.trailingAnchor, constant: -14),
            avgValue.leadingAnchor.constraint(equalTo: averageTimeCard.leadingAnchor, constant: 20),
            avgValue.topAnchor.constraint(equalTo: averageTimeCard.topAnchor, constant: 42),
            avgTitle.leadingAnchor.constraint(equalTo: averageTimeCard.leadingAnchor, constant: 20),
            avgTitle.topAnchor.constraint(equalTo: avgValue.bottomAnchor, constant: 2)
        ])

        view.addSubview(totalTimeCard)
        totalTimeCard.translatesAutoresizingMaskIntoConstraints = false
        totalTimeCard.backgroundColor = UIColor(red: 0.92, green: 0.88, blue: 0.98, alpha: 1.0)
        totalTimeCard.layer.cornerRadius = 20

        let totalIconImageView = UIImageView()
        totalIconImageView.image = UIImage(named: "Total_time")
        totalIconImageView.contentMode = .scaleAspectFit

        let totalValue = UILabel()
        totalValue.text = "91.39"
        totalValue.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        totalValue.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)

        let totalTitle = UILabel()
        totalTitle.text = "Total time"
        totalTitle.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        totalTitle.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)

        totalTimeCard.addSubview(totalIconImageView)
        totalTimeCard.addSubview(totalValue)
        totalTimeCard.addSubview(totalTitle)

        totalIconImageView.translatesAutoresizingMaskIntoConstraints = false
        totalValue.translatesAutoresizingMaskIntoConstraints = false
        totalTitle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            totalIconImageView.topAnchor.constraint(equalTo: totalTimeCard.topAnchor, constant: 24),
            totalIconImageView.trailingAnchor.constraint(equalTo: totalTimeCard.trailingAnchor, constant: -14),
            totalIconImageView.widthAnchor.constraint(equalToConstant: 27),
            totalIconImageView.heightAnchor.constraint(equalToConstant: 27),
            totalValue.leadingAnchor.constraint(equalTo: totalTimeCard.leadingAnchor, constant: 20),
            totalValue.topAnchor.constraint(equalTo: totalTimeCard.topAnchor, constant: 42),
            totalTitle.leadingAnchor.constraint(equalTo: totalTimeCard.leadingAnchor, constant: 20),
            totalTitle.topAnchor.constraint(equalTo: totalValue.bottomAnchor, constant: 4)
        ])
    }

    private func setupPerformanceCard() {
        view.addSubview(performanceCardView)
        performanceCardView.translatesAutoresizingMaskIntoConstraints = false
        performanceCardView.backgroundColor = .white
        performanceCardView.layer.cornerRadius = 20

        let trueStack = createPerformanceColumn(imageName: "True", iconBg: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), title: "True", value: "30")
        let divider1 = createDivider()
        let totalStack = createPerformanceColumn(imageName: "Total_game", iconBg: .clear, title: "Total game", value: "39")
        let divider2 = createDivider()
        let falseStack = createPerformanceColumn(imageName: "False", iconBg: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), title: "False", value: "9")

        performanceCardView.addSubview(trueStack)
        performanceCardView.addSubview(divider1)
        performanceCardView.addSubview(totalStack)
        performanceCardView.addSubview(divider2)
        performanceCardView.addSubview(falseStack)

        NSLayoutConstraint.activate([
            trueStack.leadingAnchor.constraint(equalTo: performanceCardView.leadingAnchor, constant: 12),
            trueStack.topAnchor.constraint(equalTo: performanceCardView.topAnchor, constant: 20),
            trueStack.bottomAnchor.constraint(equalTo: performanceCardView.bottomAnchor, constant: -20),
            trueStack.widthAnchor.constraint(equalTo: performanceCardView.widthAnchor, multiplier: 0.28),

            divider1.leadingAnchor.constraint(equalTo: trueStack.trailingAnchor, constant: 6),
            divider1.centerYAnchor.constraint(equalTo: performanceCardView.centerYAnchor),
            divider1.widthAnchor.constraint(equalToConstant: 1),
            divider1.heightAnchor.constraint(equalToConstant: 70),

            totalStack.centerXAnchor.constraint(equalTo: performanceCardView.centerXAnchor),
            totalStack.topAnchor.constraint(equalTo: performanceCardView.topAnchor, constant: 20),
            totalStack.bottomAnchor.constraint(equalTo: performanceCardView.bottomAnchor, constant: -20),


            divider2.leadingAnchor.constraint(equalTo: totalStack.trailingAnchor, constant: 6),
            divider2.centerYAnchor.constraint(equalTo: performanceCardView.centerYAnchor),
            divider2.widthAnchor.constraint(equalToConstant: 1),
            divider2.heightAnchor.constraint(equalToConstant: 20),

            falseStack.trailingAnchor.constraint(equalTo: performanceCardView.trailingAnchor, constant: -12),
            falseStack.topAnchor.constraint(equalTo: performanceCardView.topAnchor, constant: 20),
            falseStack.bottomAnchor.constraint(equalTo: performanceCardView.bottomAnchor, constant: -20),
            falseStack.widthAnchor.constraint(equalTo: performanceCardView.widthAnchor, multiplier: 0.28)
        ])
    }

    private func createPerformanceColumn(imageName: String, iconBg: UIColor, title: String, value: String) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false

        let iconContainer = UIView()
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.backgroundColor = iconBg
        iconContainer.layer.cornerRadius = 20
        iconContainer.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconContainer.heightAnchor.constraint(equalToConstant: 20).isActive = true

        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: imageName)
        iconImageView.contentMode = .scaleAspectFit
        iconContainer.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.85, alpha: 1.0)
        titleLabel.textAlignment = .center

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        valueLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
        valueLabel.textAlignment = .center

        stack.addArrangedSubview(iconContainer)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(valueLabel)

        return stack
    }

    private func setupPlayButton() {
        view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.backgroundColor = .white
        playButton.layer.cornerRadius = 20

        let playIconImageView = UIImageView()
        playIconImageView.image = UIImage(named: "Play_button")
        playIconImageView.contentMode = .scaleAspectFit

        let playLabel = UILabel()
        playLabel.text = "Let's Play"
        playLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        playLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)

        playButton.addSubview(playIconImageView)
        playButton.addSubview(playLabel)

        playIconImageView.translatesAutoresizingMaskIntoConstraints = false
        playLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            playIconImageView.leadingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: 90),
            playIconImageView.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            playIconImageView.widthAnchor.constraint(equalToConstant: 47),
            playIconImageView.heightAnchor.constraint(equalToConstant: 38),
            playLabel.leadingAnchor.constraint(equalTo: playIconImageView.trailingAnchor, constant: 5),
            playLabel.centerYAnchor.constraint(equalTo: playButton.centerYAnchor)
        ])

        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }

    private func setupBottomNavigation() {
        view.addSubview(bottomNavView)
        bottomNavView.translatesAutoresizingMaskIntoConstraints = false
        bottomNavView.backgroundColor = .white
        bottomNavView.layer.cornerRadius = 20
        bottomNavView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let homeIcon = UIImageView()
        homeIcon.image = UIImage(systemName: "house.fill")
        homeIcon.tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        homeIcon.contentMode = .scaleAspectFit

        let statsIcon = UIImageView()
        statsIcon.image = UIImage(systemName: "chart.bar.xaxis")
        statsIcon.tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        statsIcon.contentMode = .scaleAspectFit

        bottomNavView.addSubview(homeIcon)
        bottomNavView.addSubview(statsIcon)

        homeIcon.translatesAutoresizingMaskIntoConstraints = false
        statsIcon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            homeIcon.leadingAnchor.constraint(equalTo: bottomNavView.leadingAnchor, constant: 77),
            homeIcon.centerYAnchor.constraint(equalTo: bottomNavView.centerYAnchor, constant: -8),
            homeIcon.widthAnchor.constraint(equalToConstant: 28),
            homeIcon.heightAnchor.constraint(equalToConstant: 28),

            statsIcon.trailingAnchor.constraint(equalTo: bottomNavView.trailingAnchor, constant: -77),
            statsIcon.centerYAnchor.constraint(equalTo: bottomNavView.centerYAnchor, constant: -8),
            statsIcon.widthAnchor.constraint(equalToConstant: 24),
            statsIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),

            xpContainerView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            xpContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            xpContainerView.heightAnchor.constraint(equalToConstant: 36),

            xpIconImageView.leadingAnchor.constraint(equalTo: xpContainerView.leadingAnchor, constant: -2),
            xpIconImageView.centerYAnchor.constraint(equalTo: xpContainerView.centerYAnchor),
            xpIconImageView.widthAnchor.constraint(equalToConstant: 40),
            xpIconImageView.heightAnchor.constraint(equalToConstant: 40),

            xpLabel.leadingAnchor.constraint(equalTo: xpIconImageView.trailingAnchor, constant: 6),
            xpLabel.trailingAnchor.constraint(equalTo: xpContainerView.trailingAnchor, constant: -14),
            xpLabel.centerYAnchor.constraint(equalTo: xpContainerView.centerYAnchor),

            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            profileImageView.widthAnchor.constraint(equalToConstant: 56),
            profileImageView.heightAnchor.constraint(equalToConstant: 56),

            statsCardView.topAnchor.constraint(equalTo: xpContainerView.bottomAnchor, constant: 12),
            statsCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            statsCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statsCardView.heightAnchor.constraint(equalToConstant: 132),

            averageTimeCard.topAnchor.constraint(equalTo: statsCardView.bottomAnchor, constant: 16),
            averageTimeCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            averageTimeCard.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.44),
            averageTimeCard.heightAnchor.constraint(equalToConstant: 120),

            totalTimeCard.topAnchor.constraint(equalTo: statsCardView.bottomAnchor, constant: 16),
            totalTimeCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            totalTimeCard.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.44),
            totalTimeCard.heightAnchor.constraint(equalToConstant: 120),

            performanceCardView.topAnchor.constraint(equalTo: averageTimeCard.bottomAnchor, constant: 16),
            performanceCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            performanceCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            performanceCardView.heightAnchor.constraint(equalToConstant: 130),

            playButton.topAnchor.constraint(equalTo: performanceCardView.bottomAnchor, constant: 20),
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            playButton.heightAnchor.constraint(equalToConstant: 80),

            bottomNavView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomNavView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomNavView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomNavView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    // MARK: - Actions
    @objc private func playButtonTapped() {
        print("🎮 Play button tapped")
    }

    private func loadUserData() {
        nameLabel.text = userName
        xpLabel.text = "XP \(userXP)"

        if let imageURL = profileImageURL, let url = URL(string: imageURL) {
            loadImage(from: url)
        } else {
            setDefaultAvatar()
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.setDefaultAvatar()
                }
                return
            }
            DispatchQueue.main.async {
                self?.profileImageView.image = image
            }
        }.resume()
    }

    private func setDefaultAvatar() {
        let initials = String(userName.prefix(2)).uppercased()
        profileImageView.image = createInitialsImage(initials: initials)
    }

    private func createInitialsImage(initials: String) -> UIImage {
        let size = CGSize(width: 90, height: 90)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor(red: 0.75, green: 0.6, blue: 0.95, alpha: 1.0).cgColor)
        context?.fill(CGRect(origin: .zero, size: size))

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 36, weight: .bold),
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
}
