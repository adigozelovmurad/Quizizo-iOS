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
        // Burada Google login zamanı saxladığın token olacaq
        return UserDefaults.standard.string(forKey: "accessToken") ?? ""
    }

    // MARK: - Sualları gətir
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

    // MARK: - Cavabı göndər
    func sendAnswer(questionId: String, selectedIndex: Int, duration: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: baseURL + "questions/answer") else { return }

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

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let isCorrect = json["isCorrect"] as? Bool {
                completion(isCorrect)
            } else {
                completion(false)
            }
        }.resume()
    }
}
