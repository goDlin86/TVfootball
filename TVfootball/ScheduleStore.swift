//
//  ScheduleStore.swift
//  TVfootball
//
//  Created by Денис on 19.08.2020.
//

import Foundation
import Combine

final class ScheduleStore: ObservableObject {
    @Published private(set) var items: [ScheduleItem] = []

    private let service: ScheduleService
    init(service: ScheduleService) {
        self.service = service
    }

    func fetch() {
        service.fetch() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items): self?.items = items
                case .failure: self?.items = []
                }
            }
        }
    }
}
