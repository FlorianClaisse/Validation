//
//  In.swift
//
//
//  Created by Florian Claisse on 24/11/2023.
//

extension Validator where T: Equatable & CustomStringConvertible {
    /// Validates whether an item is contained in the supplied array.
    public static func `in`(_ array: T...) -> Validator<T> {
        .in(array)
    }
    
    /// Validates whether an item is contained in the supplied sequence.
    public static func `in`<S>(_ sequence: S) -> Validator<T> where S: Sequence, S.Element == T {
        .init {
            ValidatorResults.In(item: $0, items: .init(sequence))
        }
    }
}

extension ValidatorResults {
    /// ``ValidatorResult` of a validator that validates whether an item is contained in the supplied sequence.
    public struct In<T> where T: Equatable & CustomStringConvertible {
        /// Description of the item.
        public let item: T
        /// Descriptions of the elements of the supplied sequence.
        public let items: [T]
    }
    
}

extension ValidatorResults.In: ValidatorResult {
    /// See ``ValidatorResult/isFailure``.
    public var isFailure: Bool {
        !self.items.contains(self.item)
    }
    
    /// See ``ValidatorResult/successDescription``.
    public var successDescription: String? {
        self.makeDescription(not: false)
    }
    
    /// See ``ValidatorResult/failureDescription``.
    public var failureDescription: String? {
        self.makeDescription(not: true)
    }
    
    private func makeDescription(not: Bool) -> String {
        let description: String
        switch self.items.count {
        case 1:
            description = self.items[0].description
        case 2:
            description = "\(self.items[0].description) or \(self.items[1].description)"
        default:
            let first = self.items[0..<(self.items.count - 1)]
                .map { $0.description }.joined(separator: ", ")
            let last = self.items[self.items.count - 1].description
            description = "\(first), or \(last)"
        }
        return "is\(not ? " not" : " ") \(description)"
    }
}
