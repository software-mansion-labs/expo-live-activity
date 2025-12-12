import ActivityKit
import Foundation

struct LiveActivityAttributes: ActivityAttributes {
  struct ContentState: Codable, Hashable {
    var title: String
    var subtitle: String?
    var timerEndDateInMilliseconds: Double?
    var progress: Double?
    var imageName: String?
    var dynamicIslandImageName: String?
    /// Custom fields for Dynamic Island DSL bindings
    var customFields: [String: CustomFieldValue]?
  }

  var name: String
  var backgroundColor: String?
  var titleColor: String?
  var subtitleColor: String?
  var progressViewTint: String?
  var progressViewLabelColor: String?
  var deepLinkUrl: String?
  var timerType: DynamicIslandTimerType?
  var padding: Int?
  var paddingDetails: PaddingDetails?
  var imagePosition: String?
  var imageWidth: Int?
  var imageHeight: Int?
  var imageWidthPercent: Double?
  var imageHeightPercent: Double?
  var imageAlign: String?
  var contentFit: String?
  /// JSON-encoded Dynamic Island DSL configuration
  var dynamicIslandJSON: String?

  enum DynamicIslandTimerType: String, Codable {
    case circular
    case digital
  }

  struct PaddingDetails: Codable, Hashable {
    var top: Int?
    var bottom: Int?
    var left: Int?
    var right: Int?
    var vertical: Int?
    var horizontal: Int?
  }

  /// Wrapper for custom field values that can be String, Number, or Bool
  enum CustomFieldValue: Codable, Hashable {
    case string(String)
    case number(Double)
    case bool(Bool)

    init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      if let boolValue = try? container.decode(Bool.self) {
        self = .bool(boolValue)
      } else if let doubleValue = try? container.decode(Double.self) {
        self = .number(doubleValue)
      } else if let stringValue = try? container.decode(String.self) {
        self = .string(stringValue)
      } else {
        throw DecodingError.typeMismatch(
          CustomFieldValue.self,
          DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected String, Number, or Bool")
        )
      }
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      switch self {
      case .string(let value):
        try container.encode(value)
      case .number(let value):
        try container.encode(value)
      case .bool(let value):
        try container.encode(value)
      }
    }

    var stringValue: String {
      switch self {
      case .string(let value): return value
      case .number(let value): return String(value)
      case .bool(let value): return String(value)
      }
    }

    var doubleValue: Double? {
      switch self {
      case .number(let value): return value
      case .string(let value): return Double(value)
      case .bool: return nil
      }
    }
  }
}
