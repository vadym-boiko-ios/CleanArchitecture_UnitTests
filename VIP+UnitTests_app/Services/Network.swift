//
//  Network.swift
//  internship_app
//
//  Created by Vadym Boiko on 09.03.2022.
//

import Foundation

protocol Network {
    func request(completion: @escaping (Result<String, Error>) -> Void)
}

class NetworkService {
    init() {}
}

extension NetworkService: Network {
    func request(completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("Learn networking"))
    }
}
