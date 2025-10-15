//
//  LeaderboardViewController.swift
//  Quizizo
//
//  Created by MURAD on 9.10.2025.
//

import UIKit


class LeaderboardViewController: UIViewController {

    // MARK: - Properties
    private let segmentedControl = UISegmentedControl(items: ["Global", "Local"])
    private let tableView = UITableView()
    private let bottomNavView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)


    private let backgroundRectangle = UIImageView()


    private let ellipseImageView = UIImageView()


    private var leaderboardData: [LeaderboardEntry] = []
    private var currentPage = 1
    private let pageLimit = 50


    private let useDemoMode = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        addBackgroundOvals()
        setupRectangleBackground()
        setupEllipse()
        setupUI()
        setupConstraints()

        if useDemoMode {
            print("⚠️ Leaderboard DEMO MODE aktiv")
            loadDemoData()
        } else {
            print("📡 Leaderboard REAL API mode")
            fetchLeaderboard()
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

    // MARK: - Rectangle Background (YENİ FUNKSİYA)
    private func setupRectangleBackground() {
        backgroundRectangle.image = UIImage(named: "Rectangle")
        backgroundRectangle.contentMode = .scaleAspectFill
        backgroundRectangle.translatesAutoresizingMaskIntoConstraints = false


        view.insertSubview(backgroundRectangle, at: 3)
    }

    // MARK: - Ellipse (Figmada göstərilən yerdə)
    private func setupEllipse() {
        ellipseImageView.image = UIImage(named: "Ellipse")
        ellipseImageView.contentMode = .scaleAspectFit
        ellipseImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ellipseImageView)
    }

    // MARK: - Setup UI
    private func setupUI() {
        setupSegmentedControl()
        setupTableView()
        setupActivityIndicator()
        setupBottomNavigation()
    }

    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        segmentedControl.selectedSegmentTintColor = .white

        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor(red: 0.55, green: 0.4, blue: 0.85, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ], for: .selected)

        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.white.withAlphaComponent(0.7),
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ], for: .normal)

        segmentedControl.layer.cornerRadius = 20
        segmentedControl.layer.masksToBounds = true

        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LeaderboardCell.self, forCellReuseIdentifier: "LeaderboardCell")
        tableView.showsVerticalScrollIndicator = false
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
    }

    private func setupBottomNavigation() {
        view.addSubview(bottomNavView)
        bottomNavView.translatesAutoresizingMaskIntoConstraints = false
        bottomNavView.backgroundColor = .white
        bottomNavView.layer.cornerRadius = 20
        bottomNavView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let homeIcon = UIImageView()
        homeIcon.image = UIImage(systemName: "house.fill")
        homeIcon.tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        homeIcon.contentMode = .scaleAspectFit
        homeIcon.isUserInteractionEnabled = true
        homeIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(homeButtonTapped)))

        let statsIcon = UIImageView()
        statsIcon.image = UIImage(systemName: "chart.bar.xaxis")
        statsIcon.tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
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

        // YENİ: backgroundRectangle üçün constraints
        NSLayoutConstraint.activate([
            backgroundRectangle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            backgroundRectangle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            backgroundRectangle.topAnchor.constraint(equalTo: view.topAnchor, constant: 315),
            backgroundRectangle.bottomAnchor.constraint(equalTo: bottomNavView.topAnchor),


            ellipseImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ellipseImageView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 57),
            ellipseImageView.widthAnchor.constraint(equalToConstant: 8),
            ellipseImageView.heightAnchor.constraint(equalToConstant: 8),


            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: 313),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),


            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 60),
            tableView.leadingAnchor.constraint(equalTo: backgroundRectangle.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: backgroundRectangle.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: bottomNavView.topAnchor, constant: -10),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            bottomNavView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomNavView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomNavView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomNavView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    // MARK: - API Request
    private func fetchLeaderboard() {
        guard let token = KeychainManager.read(key: "authToken") else {
            print("❌ Token tapılmadı")
            loadDemoData()
            return
        }

        print("🔑 Token:", token.prefix(50))
        activityIndicator.startAnimating()

        let urlString = "https://api.quizizo.com/leaderboard?page=\(currentPage)&limit=\(pageLimit)"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("tr", forHTTPHeaderField: "Accept-Language")

        print("📡 Request URL:", urlString)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }

            if let error = error {
                print("❌ API Error:", error.localizedDescription)
                print("⚠️ Using demo data instead")
                self?.loadDemoData()
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📊 Status Code:", httpResponse.statusCode)

                if httpResponse.statusCode == 401 || httpResponse.statusCode == 400 {
                    print("⚠️ Backend error (\(httpResponse.statusCode)), using demo data")
                    self?.loadDemoData()
                    return
                }
            }

            guard let data = data else {
                print("❌ Data yoxdur")
                self?.loadDemoData()
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("✅ API Response:", jsonString)
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(LeaderboardResponse.self, from: data)

                print("✅ Parsed Data Count:", response.data.count)

                DispatchQueue.main.async {
                    self?.leaderboardData = response.data
                    self?.tableView.reloadData()
                    print("✅ TableView reload edildi. Row count:", self?.leaderboardData.count ?? 0)
                }
            } catch {
                print("❌ JSON Parse Error:", error)
                print("⚠️ Using demo data instead")
                self?.loadDemoData()
            }
        }.resume()
    }

    // ⚠️ DEMO MODE

    private func loadDemoData() {
        let demoData: [LeaderboardEntry] = [
            LeaderboardEntry(rank: 1, userId: "1", name: "Davis Curtis", score: 2569, country: "CA", countryFlag: "🇨🇦", profileImage: nil),
            LeaderboardEntry(rank: 2, userId: "2", name: "Alena Donin", score: 1469, country: "FR", countryFlag: "🇫🇷", profileImage: nil),
            LeaderboardEntry(rank: 3, userId: "3", name: "Craig Gouse", score: 1053, country: "CA", countryFlag: "🇨🇦", profileImage: nil),
            LeaderboardEntry(rank: 4, userId: "4", name: "Madelyn Dias", score: 590, country: "US", countryFlag: "🇺🇸", profileImage: nil),
            LeaderboardEntry(rank: 5, userId: "5", name: "Zain Vaccaro", score: 448, country: "CA", countryFlag: "🇨🇦", profileImage: nil),
            LeaderboardEntry(rank: 6, userId: "6", name: "Murad Adıgözəlov", score: 3900, country: "AZ", countryFlag: "🇦🇿", profileImage: nil),
            LeaderboardEntry(rank: 7, userId: "7", name: "John Smith", score: 387, country: "GB", countryFlag: "🇬🇧", profileImage: nil),
            LeaderboardEntry(rank: 8, userId: "8", name: "Maria Garcia", score: 356, country: "ES", countryFlag: "🇪🇸", profileImage: nil),
            LeaderboardEntry(rank: 9, userId: "9", name: "Ali Məmmədov", score: 298, country: "AZ", countryFlag: "🇦🇿", profileImage: nil),
            LeaderboardEntry(rank: 10, userId: "10", name: "Emma Wilson", score: 267, country: "US", countryFlag: "🇺🇸", profileImage: nil)
        ]

        DispatchQueue.main.async { [weak self] in
            self?.leaderboardData = demoData
            self?.tableView.reloadData()
            print("✅ Demo data loaded: \(demoData.count) entries")
        }
    }

    // MARK: - Actions
    @objc private func segmentChanged() {
        if useDemoMode {
            loadDemoData()
        } else {
            fetchLeaderboard()
        }
    }

    @objc private func homeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate & DataSource
extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
        let entry = leaderboardData[indexPath.row]
        let isTopRank = entry.rank <= 3
        cell.configure(
            rank: entry.rank,
            name: entry.name,
            points: String(entry.score),
            flag: entry.countryFlag,
            isTopRank: isTopRank,
            profileImage: entry.profileImage
        )
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - Data Models
struct LeaderboardResponse: Codable {
    let data: [LeaderboardEntry]
}

struct LeaderboardEntry: Codable {
    let rank: Int
    let userId: String
    let name: String
    let score: Int
    let country: String
    let countryFlag: String
    let profileImage: String?

}

// MARK: - Custom Cell (Figma Design)
class LeaderboardCell: UITableViewCell {
    private let containerView = UIView()
    private let rankImageView = UIImageView() 
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let pointsLabel = UILabel()
    private let flagImageView = UIImageView()
    private let medalImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20


        rankImageView.contentMode = .scaleAspectFit
        rankImageView.translatesAutoresizingMaskIntoConstraints = false
        rankImageView.tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)


        avatarImageView.layer.cornerRadius = 22
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = UIColor(red: 0.85, green: 0.75, blue: 0.95, alpha: 1.0)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        nameLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false


        pointsLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        pointsLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1.0)
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false

                flagImageView.contentMode = .scaleAspectFit
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        flagImageView.layer.cornerRadius = 0
        flagImageView.clipsToBounds = true


        medalImageView.contentMode = .scaleAspectFit
        medalImageView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(rankImageView)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(flagImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(pointsLabel)
        containerView.addSubview(medalImageView)

        NSLayoutConstraint.activate([

            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 14),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 285),
            containerView.heightAnchor.constraint(equalToConstant: 62),


            rankImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            rankImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rankImageView.widthAnchor.constraint(equalToConstant: 24),
            rankImageView.heightAnchor.constraint(equalToConstant: 24),


            avatarImageView.leadingAnchor.constraint(equalTo: rankImageView.trailingAnchor, constant: 12),
            avatarImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            avatarImageView.widthAnchor.constraint(equalToConstant: 48),
            avatarImageView.heightAnchor.constraint(equalToConstant: 48),


            flagImageView.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 2),
            flagImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 2),
            flagImageView.widthAnchor.constraint(equalToConstant: 20),
            flagImageView.heightAnchor.constraint(equalToConstant: 20),


            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18),


            pointsLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            pointsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),


            medalImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            medalImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            medalImageView.widthAnchor.constraint(equalToConstant: 40),
            medalImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configure(rank: Int, name: String, points: String, flag: String, isTopRank: Bool, profileImage: String?) {
        // SF Symbol ilə rank göstər
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        rankImageView.image = UIImage(systemName: "\(rank).circle", withConfiguration: config)

        nameLabel.text = name
        pointsLabel.text = "\(points) points"


        flagImageView.image = UIImage(named: "Portugal")
        // Medal dizaynı
        if isTopRank {
            if rank == 1 {
                medalImageView.image = UIImage(named: "Medal_1")
                medalImageView.tintColor = nil
            } else if rank == 2 {
                medalImageView.image = UIImage(named: "Medal_2")
                medalImageView.tintColor = nil
            } else if rank == 3 {
                medalImageView.image = UIImage(named: "Medal_3")
                medalImageView.tintColor = nil
            }
            medalImageView.isHidden = false
        } else {
            medalImageView.isHidden = true
        }

        // Avatar
        if let imageURL = profileImage, let url = URL(string: imageURL) {
            loadImage(from: url)
        } else {
            avatarImageView.image = createAvatarImage(name: name)
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }.resume()
    }

    private func createAvatarImage(name: String) -> UIImage {
        let size = CGSize(width: 44, height: 44)
        let initials = String(name.prefix(2)).uppercased()

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()

        let colors: [UIColor] = [
            UIColor(red: 0.85, green: 0.75, blue: 0.95, alpha: 1.0),
            UIColor(red: 0.95, green: 0.75, blue: 0.85, alpha: 1.0),
            UIColor(red: 0.75, green: 0.85, blue: 0.95, alpha: 1.0)
        ]
        let randomColor = colors.randomElement() ?? colors[0]

        context?.setFillColor(randomColor.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold),
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
