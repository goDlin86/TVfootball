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

    func fetch(handler: @escaping (Result<[ScheduleItem], Error>) -> Void) {
        guard
            var urlComponents = URLComponents(string: "https://tv.mail.ru/ajax/channel/")
            else { preconditionFailure("Can't create url components...") }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"

        urlComponents.queryItems = [
            URLQueryItem(name: "region_id", value: "24"), // Voronezh
            URLQueryItem(name: "channel_id", value: "2060"), // MatchTV
            URLQueryItem(name: "date", value: dateFormatter.string(from: date)) // YYYY-MM-DD
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
                    handler(.success(response?.items ?? []))
                } catch {
                    print(error)
                    handler(.failure(error))
                }
            }
        }.resume()
    }
}


struct ScheduleItem: Decodable, Identifiable {
    var id: UUID
    
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
        id = UUID()
        
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
