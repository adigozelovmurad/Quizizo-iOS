//
//   APIManager.swift
//  Quizizo
//
//  Created by MURAD on 26.10.2025.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private init() {}

    private let baseURL = "https://api.quizizo.com/"

    private var token: String {
        return KeychainManager.read(key: "authToken") ?? ""
    }

    func fetchUserStats(completion: @escaping ([String: Any]?) -> Void) {
        guard let url = URL(string: baseURL + "user/stats") else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("en", forHTTPHeaderField: "X-Language")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                completion(json)
            } else {
                completion(nil)
            }
        }.resume()
    }

    func fetchUserProfile(completion: @escaping ([String: Any]?) -> Void) {
        guard let url = URL(string: baseURL + "user/me") else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("en", forHTTPHeaderField: "X-Language")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                completion(json)
            } else {
                completion(nil)
            }
        }.resume()
    }

    func fetchNextQuestion(completion: @escaping ([String: Any]?) -> Void) {
        guard let url = URL(string: baseURL + "questions/next") else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("en", forHTTPHeaderField: "X-Language")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                completion(json)
            } else {
                completion(nil)
            }
        }.resume()
    }

    func sendAnswer(questionId: String, selectedIndex: Int, duration: Int,
                    completion: @escaping (_ isCorrect: Bool, _ correctIndex: Int?) -> Void) {

        guard let url = URL(string: "\(baseURL)questions/answer") else {
            print("❌ Invalid URL")
            completion(false, nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "questionId": questionId,
            "selectedIndex": selectedIndex,
            "duration": duration
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        print("📤 Sending answer to backend...")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion(false, nil)
                return
            }

            if let http = response as? HTTPURLResponse {
                print("🟦 ANSWER status code: \(http.statusCode)")
            }

            guard let data = data else {
                print("❌ No data received")
                completion(false, nil)
                return
            }

            // ✅ Backend cavabını print et
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 ANSWER Response: \(jsonString)")
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("✅ Parsed JSON: \(json)")

                    let dataObj = json["data"] as? [String: Any]
                    let isCorrect = dataObj?["isCorrect"] as? Bool ?? false

                    // ✅ Backend correctIndex göndərirsə, onu al
                    let correctIndex = dataObj?["correctIndex"] as? Int

                    if let correctIndex = correctIndex {
                        print("✅ Backend correctIndex göndərdi: \(correctIndex)")
                    } else {
                        print("⚠️ Backend correctIndex göndərmədi")
                    }

                    completion(isCorrect, correctIndex)
                    return
                }

                print("❌ Invalid JSON structure")
                completion(false, nil)
            } catch {
                print("❌ JSON parse error: \(error)")
                completion(false, nil)
            }

        }.resume()
    }

    func fetchLeaderboard(page: Int = 1, limit: Int = 50, completion: @escaping (LeaderboardResponse?) -> Void) {
        guard let url = URL(string: baseURL + "leaderboard?page=\(page)&limit=\(limit)") else {
            print("Invalid URL")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("tr", forHTTPHeaderField: "Accept-Language")

        print(" Leaderboard API request: \(url.absoluteString)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📊 Status Code: \(httpResponse.statusCode)")

                if httpResponse.statusCode != 200 {
                    print(" API returned status code: \(httpResponse.statusCode)")
                    completion(nil)
                    return
                }
            }

            guard let data = data else {
                print("❌ No data received")
                completion(nil)
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print(" API Response: \(jsonString)")
            }

            do {
                let decoder = JSONDecoder()
                let leaderboardResponse = try decoder.decode(LeaderboardResponse.self, from: data)
                print( "Successfully parsed leaderboard data")
                completion(leaderboardResponse)
            } catch {
                print("❌ JSON Parse Error: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

struct LeaderboardResponse: Codable {
    let status: String
    let message: String
    let data: LeaderboardData
}

struct LeaderboardData: Codable {
    let userRank: LeaderboardEntry
    let leaders: [LeaderboardEntry]
}

struct LeaderboardEntry: Codable {
    let userId: String
    let name: String
    let score: Int
    let rank: String
    let rankPosition: Int
    let country: String
    let profilePicture: String?

    var countryFlag: String {
        return flag(for: country)
    }

    private func flag(for countryCode: String) -> String {
        let base: UInt32 = 127397
        var s = ""
        countryCode.uppercased().unicodeScalars.forEach {
            s.unicodeScalars.append(UnicodeScalar(base + $0.value)!)
        }
        return s
    }
}
