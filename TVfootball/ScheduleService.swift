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
    
    typealias completionHandler = (Data?, URLResponse?, Error?) -> Void

    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    func fetch(date: Date, handler: @escaping (Result<ScheduleDay, Error>) -> Void) {
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
                                items: response?.items.filter { $0.title.contains("Футбол") } ?? []
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

struct ScheduleItem: Decodable {
    let title: String
    let time: String
    let url: String
    //let hour: Int
    //let min: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case episode_title
        case start
        case url
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try values.decode(String.self, forKey: .name)
        let ep = try values.decode(String.self, forKey: .episode_title)
        title = name + " " + ep
        
        time = try values.decode(String.self, forKey: .start)
        
        let u = try values.decode(String.self, forKey: .url)
        url = "https://tv.mail.ru" + u
    }
}

struct ScheduleResponse: Decodable {
    var items: [ScheduleItem]
          
    enum CodingKeys: String, CodingKey {
        case schedule
    }
    
    enum ScheduleKeys: String, CodingKey {
        case event
    }
    
    enum EventKeys: String, CodingKey {
        case current
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        var schedules = try values.nestedUnkeyedContainer(forKey: .schedule)
        
        //while !schedules.isAtEnd {
            let schedule = try schedules.nestedContainer(keyedBy: ScheduleKeys.self)
            let current = try schedule.nestedContainer(keyedBy: EventKeys.self, forKey: .event)
            
            items = try current.decode([ScheduleItem].self, forKey: .current)
        //}
    }
}
