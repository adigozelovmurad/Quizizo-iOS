//
//  SettingsViewController.swift
//  Quizizo
//
//  Created by MURAD on 9.11.2025.
//

import UIKit

class SettingsViewController: UIViewController {

    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private var settings: [(title: String, isOn: Bool)] = [
        ("Notifications", true),
        ("Sound Effects", true),
        ("Dark Mode", false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground

        // Title
        titleLabel.text = "Settings"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.45, green: 0.3, blue: 0.85, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Close button
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = UIColor(red: 0.45, green: 0.3, blue: 0.85, alpha: 1.0)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)

        // Table
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let setting = settings[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = setting.title
        content.textProperties.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        cell.contentConfiguration = content

        let toggle = UISwitch()
        toggle.isOn = setting.isOn
        toggle.tag = indexPath.row
        toggle.onTintColor = UIColor(red: 0.6, green: 0.45, blue: 0.95, alpha: 1.0)
        toggle.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = toggle

        return cell
    }

    @objc private func switchChanged(_ sender: UISwitch) {
        let index = sender.tag
        settings[index].isOn = sender.isOn

        let title = settings[index].title
        print("⚙️ \(title) is now \(sender.isOn ? "ON" : "OFF")")

        if title == "Dark Mode" {
            toggleDarkMode(isOn: sender.isOn)
        }
    }

    private func toggleDarkMode(isOn: Bool) {
        if let window = UIApplication.shared.windows.first {
            window.overrideUserInterfaceStyle = isOn ? .dark : .light
        }
    }
}
