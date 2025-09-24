//
//  Padding.swift
//  ExpoLiveActivity
//

import Foundation

enum Padding: Codable, Hashable {
    case number(Int)
    case values(Values)

    struct Values: Codable, Hashable {
        var top: Int?
        var bottom: Int?
        var left: Int?
        var right: Int?
        var horizontal: Int?
        var vertical: Int?
    }

    // MARK: - Codable
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intVal = try? container.decode(Int.self) {
            self = .number(intVal)
        } else if let objVal = try? container.decode(Values.self) {
            self = .values(objVal)
        } else {
            throw DecodingError.typeMismatch(
                Padding.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected Int or Values object"
                )
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .number(let n):
            try container.encode(n)
        case .values(let v):
            try container.encode(v)
        }
    }
}

#if canImport(ExpoModulesCore)
import ExpoModulesCore

// MARK: - Expo AnyArgument
extension Padding: AnyArgument {
    public static func fromArgument(_ argument: Any?) throws -> Padding {
        if let intVal = argument as? Int {
            return .number(intVal)
        }

        if let dict = argument as? [String: Any] {
            let values = Values(
                top: dict["top"] as? Int,
                bottom: dict["bottom"] as? Int,
                left: dict["left"] as? Int,
                right: dict["right"] as? Int,
                horizontal: dict["horizontal"] as? Int,
                vertical: dict["vertical"] as? Int
            )
            return .values(values)
        }

        throw NSError(
            domain: "ExpoLiveActivity.Padding",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Invalid argument for Padding: \(String(describing: argument))"]
        )
    }

    public func toArgument() -> Any {
        switch self {
        case .number(let n):
            return n
        case .values(let v):
            var dict: [String: Any] = [:]
            if let top = v.top { dict["top"] = top }
            if let bottom = v.bottom { dict["bottom"] = bottom }
            if let left = v.left { dict["left"] = left }
            if let right = v.right { dict["right"] = right }
            if let horizontal = v.horizontal { dict["horizontal"] = horizontal }
            if let vertical = v.vertical { dict["vertical"] = vertical }
            return dict
        }
    }
}
#endif