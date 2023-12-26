//
//  ScheduleService.swift
//  TVfootball
//
//  Created by Денис on 19.08.2020.
//

import Foundation

class ScheduleService {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    func fetch(date: Date, sports: [String], handler: @escaping (Result<ScheduleDay, Error>) -> Void) {
        guard
            var urlComponents = URLComponents(string: "https://tv.mail.ru/ajax/channel/")
            else { preconditionFailure("Can't create url components...") }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "ru_Ru")
        dayFormatter.dateFormat = "EEEE, dd MMM"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "region_id", value: "24"), // Voronezh
            URLQueryItem(name: "channel_id", value: "2060"), // MatchTV
            URLQueryItem(name: "date", value: dateFormatter.string(for: date)) // YYYY-MM-DD
        ]

        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }

        session.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                handler(.failure(error))
            } else {
                do {
                    let data = data ?? Data()
                    let response = try self?.decoder.decode(ScheduleResponse.self, from: data)
                    handler(
                        .success(
                            ScheduleDay(
                                date: dayFormatter.string(for: date) ?? "23 aug",
                                items: response?.schedule[0].event.current.filter { sports.contains(where: $0.name.contains) } ?? []
                            )
                        )
                    )
                } catch {
                    print(error)
                    handler(.failure(error))
                }
            }
        }.resume()
    }
}


struct ScheduleDay {
    let date: String
    let items: [ScheduleItem]
}

struct ScheduleResponse: Decodable {
    let schedule: [Schedule]
    
    struct Schedule: Decodable {
        let event: Event
        
        struct Event: Decodable {
            let current: [ScheduleItem]
        }
    }
}

struct ScheduleItem: Decodable {
    let name: String
    let start: String
    let url: String
}
