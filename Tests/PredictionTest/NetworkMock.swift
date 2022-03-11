//
//  NetworkMock.swift
//  Tests
//
//  Created by Vadym Boiko on 10.03.2022.
//

import Foundation
@testable import VIP_UnitTests_app

class NetworkMock: Network {
    var requestCalledCount = 0
    var requestCallReturnValue: Result<String, Error>!
    
    func request(completion: @escaping (Result<String, Error>) -> Void) {
        requestCalledCount += 1
        completion(requestCallReturnValue)
    }
}
