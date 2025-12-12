import Foundation
import SwiftUI

// MARK: - Dynamic Island Element Types

/// Union type wrapper for all Dynamic Island elements
public enum DIElement: Codable, Hashable {
  case text(DIText)
  case sfSymbol(DISFSymbol)
  case image(DIImage)
  case progress(DIProgress)
  case gauge(DIGauge)
  case timer(DITimer)
  case button(DIButton)
  case hstack(DIHStack)
  case vstack(DIVStack)
  case zstack(DIZStack)
  case spacer(DISpacer)

  private enum CodingKeys: String, CodingKey {
    case type
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let type = try container.decode(String.self, forKey: .type)

    let singleValueContainer = try decoder.singleValueContainer()

    switch type {
    case "text":
      self = .text(try singleValueContainer.decode(DIText.self))
    case "sfSymbol":
      self = .sfSymbol(try singleValueContainer.decode(DISFSymbol.self))
    case "image":
      self = .image(try singleValueContainer.decode(DIImage.self))
    case "progress":
      self = .progress(try singleValueContainer.decode(DIProgress.self))
    case "gauge":
      self = .gauge(try singleValueContainer.decode(DIGauge.self))
    case "timer":
      self = .timer(try singleValueContainer.decode(DITimer.self))
    case "button":
      self = .button(try singleValueContainer.decode(DIButton.self))
    case "hstack":
      self = .hstack(try singleValueContainer.decode(DIHStack.self))
    case "vstack":
      self = .vstack(try singleValueContainer.decode(DIVStack.self))
    case "zstack":
      self = .zstack(try singleValueContainer.decode(DIZStack.self))
    case "spacer":
      self = .spacer(try singleValueContainer.decode(DISpacer.self))
    default:
      throw DecodingError.dataCorruptedError(
        forKey: .type,
        in: container,
        debugDescription: "Unknown element type: \(type)"
      )
    }
  }

  public func encode(to encoder: Encoder) throws {
    switch self {
    case .text(let element):
      try element.encode(to: encoder)
    case .sfSymbol(let element):
      try element.encode(to: encoder)
    case .image(let element):
      try element.encode(to: encoder)
    case .progress(let element):
      try element.encode(to: encoder)
    case .gauge(let element):
      try element.encode(to: encoder)
    case .timer(let element):
      try element.encode(to: encoder)
    case .button(let element):
      try element.encode(to: encoder)
    case .hstack(let element):
      try element.encode(to: encoder)
    case .vstack(let element):
      try element.encode(to: encoder)
    case .zstack(let element):
      try element.encode(to: encoder)
    case .spacer(let element):
      try element.encode(to: encoder)
    }
  }
}

// MARK: - Text Element

public struct DIText: Codable, Hashable {
  public let type: String
  public let value: String
  public let font: DIFont?
  public let weight: DIFontWeight?
  public let color: String?
  public let minimumScaleFactor: Double?

  public init(
    value: String,
    font: DIFont? = nil,
    weight: DIFontWeight? = nil,
    color: String? = nil,
    minimumScaleFactor: Double? = nil
  ) {
    self.type = "text"
    self.value = value
    self.font = font
    self.weight = weight
    self.color = color
    self.minimumScaleFactor = minimumScaleFactor
  }
}

public enum DIFont: String, Codable, Hashable {
  case caption
  case caption2
  case footnote
  case body
  case subheadline
  case headline
  case title3
  case title2
  case title

  public var swiftUIFont: Font {
    switch self {
    case .caption: return .caption
    case .caption2: return .caption2
    case .footnote: return .footnote
    case .body: return .body
    case .subheadline: return .subheadline
    case .headline: return .headline
    case .title3: return .title3
    case .title2: return .title2
    case .title: return .title
    }
  }
}

public enum DIFontWeight: String, Codable, Hashable {
  case ultraLight
  case thin
  case light
  case regular
  case medium
  case semibold
  case bold
  case heavy
  case black

  public var swiftUIWeight: Font.Weight {
    switch self {
    case .ultraLight: return .ultraLight
    case .thin: return .thin
    case .light: return .light
    case .regular: return .regular
    case .medium: return .medium
    case .semibold: return .semibold
    case .bold: return .bold
    case .heavy: return .heavy
    case .black: return .black
    }
  }
}

// MARK: - SF Symbol Element

public struct DISFSymbol: Codable, Hashable {
  public let type: String
  public let name: String
  public let color: String?
  public let size: Double?
  public let weight: DIFontWeight?
  public let renderingMode: DISFRenderingMode?
  public let secondaryColor: String?
  public let tertiaryColor: String?

  public init(
    name: String,
    color: String? = nil,
    size: Double? = nil,
    weight: DIFontWeight? = nil,
    renderingMode: DISFRenderingMode? = nil,
    secondaryColor: String? = nil,
    tertiaryColor: String? = nil
  ) {
    self.type = "sfSymbol"
    self.name = name
    self.color = color
    self.size = size
    self.weight = weight
    self.renderingMode = renderingMode
    self.secondaryColor = secondaryColor
    self.tertiaryColor = tertiaryColor
  }
}

public enum DISFRenderingMode: String, Codable, Hashable {
  case monochrome
  case hierarchical
  case palette
  case multicolor

  public var swiftUIMode: SymbolRenderingMode {
    switch self {
    case .monochrome: return .monochrome
    case .hierarchical: return .hierarchical
    case .palette: return .palette
    case .multicolor: return .multicolor
    }
  }
}

// MARK: - Image Element

public struct DIImage: Codable, Hashable {
  public let type: String
  public let source: String
  public let width: Double?
  public let height: Double?
  public let contentMode: DIContentMode?
  public let tint: String?

  public init(
    source: String,
    width: Double? = nil,
    height: Double? = nil,
    contentMode: DIContentMode? = nil,
    tint: String? = nil
  ) {
    self.type = "image"
    self.source = source
    self.width = width
    self.height = height
    self.contentMode = contentMode
    self.tint = tint
  }
}

public enum DIContentMode: String, Codable, Hashable {
  case fit
  case fill
}

// MARK: - Progress Element

public struct DIProgress: Codable, Hashable {
  public let type: String
  public let value: String
  public let style: DIProgressStyle?
  public let tint: String?
  public let showLabel: Bool?

  public init(
    value: String,
    style: DIProgressStyle? = nil,
    tint: String? = nil,
    showLabel: Bool? = nil
  ) {
    self.type = "progress"
    self.value = value
    self.style = style
    self.tint = tint
    self.showLabel = showLabel
  }
}

public enum DIProgressStyle: String, Codable, Hashable {
  case linear
  case circular
}

// MARK: - Gauge Element

public struct DIGauge: Codable, Hashable {
  public let type: String
  public let value: String
  public let style: DIGaugeStyle?
  public let tint: String?
  public let min: Double?
  public let max: Double?
  public let label: String?

  public init(
    value: String,
    style: DIGaugeStyle? = nil,
    tint: String? = nil,
    min: Double? = nil,
    max: Double? = nil,
    label: String? = nil
  ) {
    self.type = "gauge"
    self.value = value
    self.style = style
    self.tint = tint
    self.min = min
    self.max = max
    self.label = label
  }
}

public enum DIGaugeStyle: String, Codable, Hashable {
  case circular
  case linear
  case capacityCircular
}

// MARK: - Timer Element

public struct DITimer: Codable, Hashable {
  public let type: String
  public let endDate: String
  public let style: DITimerStyle?
  public let tint: String?
  public let countsDown: Bool?

  public init(
    endDate: String,
    style: DITimerStyle? = nil,
    tint: String? = nil,
    countsDown: Bool? = nil
  ) {
    self.type = "timer"
    self.endDate = endDate
    self.style = style
    self.tint = tint
    self.countsDown = countsDown
  }
}

public enum DITimerStyle: String, Codable, Hashable {
  case compact
  case offset
  case relative
  case timer
}

// MARK: - Button Element

public struct DIButton: Codable, Hashable {
  public let type: String
  public let id: String
  public let label: DIButtonLabel
  public let style: DIButtonStyle?
  public let tint: String?

  public init(
    id: String,
    label: DIButtonLabel,
    style: DIButtonStyle? = nil,
    tint: String? = nil
  ) {
    self.type = "button"
    self.id = id
    self.label = label
    self.style = style
    self.tint = tint
  }
}

/// Button label can be either a string or an SF Symbol
public enum DIButtonLabel: Codable, Hashable {
  case text(String)
  case symbol(DISFSymbol)

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()

    // Try to decode as string first
    if let text = try? container.decode(String.self) {
      self = .text(text)
      return
    }

    // Try to decode as SF Symbol
    if let symbol = try? container.decode(DISFSymbol.self) {
      self = .symbol(symbol)
      return
    }

    throw DecodingError.dataCorruptedError(
      in: container,
      debugDescription: "Button label must be a string or SF Symbol object"
    )
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .text(let text):
      try container.encode(text)
    case .symbol(let symbol):
      try container.encode(symbol)
    }
  }
}

public enum DIButtonStyle: String, Codable, Hashable {
  case plain
  case bordered
  case borderedProminent
}

// MARK: - Stack Elements

public struct DIHStack: Codable, Hashable {
  public let type: String
  public let children: [DIElement]
  public let spacing: Double?
  public let alignment: DIVerticalAlignment?

  public init(
    children: [DIElement],
    spacing: Double? = nil,
    alignment: DIVerticalAlignment? = nil
  ) {
    self.type = "hstack"
    self.children = children
    self.spacing = spacing
    self.alignment = alignment
  }
}

public struct DIVStack: Codable, Hashable {
  public let type: String
  public let children: [DIElement]
  public let spacing: Double?
  public let alignment: DIHorizontalAlignment?

  public init(
    children: [DIElement],
    spacing: Double? = nil,
    alignment: DIHorizontalAlignment? = nil
  ) {
    self.type = "vstack"
    self.children = children
    self.spacing = spacing
    self.alignment = alignment
  }
}

public struct DIZStack: Codable, Hashable {
  public let type: String
  public let children: [DIElement]
  public let alignment: DIZAlignment?

  public init(
    children: [DIElement],
    alignment: DIZAlignment? = nil
  ) {
    self.type = "zstack"
    self.children = children
    self.alignment = alignment
  }
}

public enum DIVerticalAlignment: String, Codable, Hashable {
  case top
  case center
  case bottom

  public var swiftUIAlignment: VerticalAlignment {
    switch self {
    case .top: return .top
    case .center: return .center
    case .bottom: return .bottom
    }
  }
}

public enum DIHorizontalAlignment: String, Codable, Hashable {
  case leading
  case center
  case trailing

  public var swiftUIAlignment: HorizontalAlignment {
    switch self {
    case .leading: return .leading
    case .center: return .center
    case .trailing: return .trailing
    }
  }
}

public enum DIZAlignment: String, Codable, Hashable {
  case center
  case topLeading
  case top
  case topTrailing
  case leading
  case trailing
  case bottomLeading
  case bottom
  case bottomTrailing

  public var swiftUIAlignment: Alignment {
    switch self {
    case .center: return .center
    case .topLeading: return .topLeading
    case .top: return .top
    case .topTrailing: return .topTrailing
    case .leading: return .leading
    case .trailing: return .trailing
    case .bottomLeading: return .bottomLeading
    case .bottom: return .bottom
    case .bottomTrailing: return .bottomTrailing
    }
  }
}

// MARK: - Spacer Element

public struct DISpacer: Codable, Hashable {
  public let type: String
  public let minLength: Double?

  public init(minLength: Double? = nil) {
    self.type = "spacer"
    self.minLength = minLength
  }
}

// MARK: - Presentation Configurations

public struct DICompactConfig: Codable, Hashable {
  public let leading: DIElement?
  public let trailing: DIElement?

  public init(leading: DIElement? = nil, trailing: DIElement? = nil) {
    self.leading = leading
    self.trailing = trailing
  }
}

public struct DIMinimalConfig: Codable, Hashable {
  public let content: DIElement

  public init(content: DIElement) {
    self.content = content
  }
}

public struct DIExpandedConfig: Codable, Hashable {
  public let leading: DIElement?
  public let leadingPriority: Double?
  public let trailing: DIElement?
  public let trailingPriority: Double?
  public let center: DIElement?
  public let bottom: DIElement?

  public init(
    leading: DIElement? = nil,
    leadingPriority: Double? = nil,
    trailing: DIElement? = nil,
    trailingPriority: Double? = nil,
    center: DIElement? = nil,
    bottom: DIElement? = nil
  ) {
    self.leading = leading
    self.leadingPriority = leadingPriority
    self.trailing = trailing
    self.trailingPriority = trailingPriority
    self.center = center
    self.bottom = bottom
  }
}

public struct DynamicIslandDSLConfig: Codable, Hashable {
  public let compact: DICompactConfig?
  public let minimal: DIMinimalConfig?
  public let expanded: DIExpandedConfig?

  public init(
    compact: DICompactConfig? = nil,
    minimal: DIMinimalConfig? = nil,
    expanded: DIExpandedConfig? = nil
  ) {
    self.compact = compact
    self.minimal = minimal
    self.expanded = expanded
  }

  /// Decode from JSON string
  public static func from(json: String) -> DynamicIslandDSLConfig? {
    guard let data = json.data(using: .utf8) else { return nil }
    return try? JSONDecoder().decode(DynamicIslandDSLConfig.self, from: data)
  }
}
