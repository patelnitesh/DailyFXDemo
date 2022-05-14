//
//  ResultState.swift
//  DailyFXDemo
//
//  Created by Nitesh Patel on 13/05/2022.
//

// https://twittemb.github.io/posts/2021-12-10-EquatableError/


import Foundation

enum Reason: Equatable {
    case badNetwork
    case noNetwork
}

struct NetworkError: Error, Equatable {
    let code: Int
    let reason: Reason
    let isRecoverable: Bool
    
    static func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
        lhs.code == rhs.code && lhs.reason == rhs.reason
    }
}
struct DatabaseError: Error, Equatable {}

enum StateError: Error, Equatable {
    case network(NetworkError)
    case database(DatabaseError)
}

enum ResultState: Equatable {
    case loading
    case success
    case failed(EquatableError)
}


struct EquatableError: Error, Equatable, CustomStringConvertible {
    let base: Error
    private let equals: (Error) -> Bool
    
    var description: String {
           "\(self.base)"
    }
    
    var localizedDescription: String {
            self.base.localizedDescription
    }

    init<Base: Error>(_ base: Base) {
        self.base = base
        self.equals = { String(reflecting: $0) == String(reflecting: base) }
    }

    init<Base: Error & Equatable>(_ base: Base) {
        self.base = base
        self.equals = { ($0 as? Base) == base }
    }

    static func == (lhs: EquatableError, rhs: EquatableError) -> Bool {
        lhs.equals(rhs.base)
    }
    
    func asError<Base: Error>(type: Base.Type) -> Base? {
            self.base as? Base
        }
}

extension Error where Self: Equatable {
    func toEquatableError() -> EquatableError {
        EquatableError(self)
    }
}

extension Error {
    func toEquatableError() -> EquatableError {
        EquatableError(self)
    }
}
