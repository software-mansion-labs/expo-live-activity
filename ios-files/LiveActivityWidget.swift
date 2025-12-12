import ActivityKit
import SwiftUI
import WidgetKit

public struct LiveActivityAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var title: String
    var subtitle: String?
    var timerEndDateInMilliseconds: Double?
    var progress: Double?
    var imageName: String?
    var dynamicIslandImageName: String?
    /// Custom fields for Dynamic Island DSL bindings
    var customFields: [String: CustomFieldValue]?

    public init(
      title: String,
      subtitle: String? = nil,
      timerEndDateInMilliseconds: Double? = nil,
      progress: Double? = nil,
      imageName: String? = nil,
      dynamicIslandImageName: String? = nil,
      customFields: [String: CustomFieldValue]? = nil
    ) {
      self.title = title
      self.subtitle = subtitle
      self.timerEndDateInMilliseconds = timerEndDateInMilliseconds
      self.progress = progress
      self.imageName = imageName
      self.dynamicIslandImageName = dynamicIslandImageName
      self.customFields = customFields
    }
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

  public init(
    name: String,
    backgroundColor: String? = nil,
    titleColor: String? = nil,
    subtitleColor: String? = nil,
    progressViewTint: String? = nil,
    progressViewLabelColor: String? = nil,
    deepLinkUrl: String? = nil,
    timerType: DynamicIslandTimerType? = nil,
    padding: Int? = nil,
    paddingDetails: PaddingDetails? = nil,
    imagePosition: String? = nil,
    imageWidth: Int? = nil,
    imageHeight: Int? = nil,
    imageWidthPercent: Double? = nil,
    imageHeightPercent: Double? = nil,
    imageAlign: String? = nil,
    contentFit: String? = nil,
    dynamicIslandJSON: String? = nil
  ) {
    self.name = name
    self.backgroundColor = backgroundColor
    self.titleColor = titleColor
    self.subtitleColor = subtitleColor
    self.progressViewTint = progressViewTint
    self.progressViewLabelColor = progressViewLabelColor
    self.deepLinkUrl = deepLinkUrl
    self.timerType = timerType
    self.padding = padding
    self.paddingDetails = paddingDetails
    self.imagePosition = imagePosition
    self.imageWidth = imageWidth
    self.imageHeight = imageHeight
    self.imageWidthPercent = imageWidthPercent
    self.imageHeightPercent = imageHeightPercent
    self.imageAlign = imageAlign
    self.contentFit = contentFit
    self.dynamicIslandJSON = dynamicIslandJSON
  }

  public enum DynamicIslandTimerType: String, Codable {
    case circular
    case digital
  }

  public struct PaddingDetails: Codable, Hashable {
    var top: Int?
    var bottom: Int?
    var left: Int?
    var right: Int?
    var vertical: Int?
    var horizontal: Int?

    public init(
      top: Int? = nil,
      bottom: Int? = nil,
      left: Int? = nil,
      right: Int? = nil,
      vertical: Int? = nil,
      horizontal: Int? = nil
    ) {
      self.top = top
      self.bottom = bottom
      self.left = left
      self.right = right
      self.vertical = vertical
      self.horizontal = horizontal
    }
  }

  /// Wrapper for custom field values that can be String, Number, or Bool
  public enum CustomFieldValue: Codable, Hashable {
    case string(String)
    case number(Double)
    case bool(Bool)

    public init(from decoder: Decoder) throws {
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

    public func encode(to encoder: Encoder) throws {
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

    public var stringValue: String {
      switch self {
      case .string(let value): return value
      case .number(let value): return String(value)
      case .bool(let value): return String(value)
      }
    }

    public var doubleValue: Double? {
      switch self {
      case .number(let value): return value
      case .string(let value): return Double(value)
      case .bool: return nil
      }
    }
  }

  /// Decode the Dynamic Island DSL configuration from JSON
  public func decodeDynamicIslandConfig() -> DynamicIslandDSLConfig? {
    guard let json = dynamicIslandJSON else { return nil }
    return DynamicIslandDSLConfig.from(json: json)
  }
}

@available(iOS 16.1, *)
public struct LiveActivityWidget: Widget {
  public var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivityAttributes.self) { context in
      LiveActivityView(contentState: context.state, attributes: context.attributes)
        .activityBackgroundTint(
          context.attributes.backgroundColor.map { Color(hex: $0) }
        )
        .activitySystemActionForegroundColor(Color.black)
        .applyWidgetURL(from: context.attributes.deepLinkUrl)
    } dynamicIsland: { context in
      let renderer = DIRenderer(state: context.state, attributes: context.attributes)
      let dslConfig = context.attributes.decodeDynamicIslandConfig()

      DynamicIsland {
        // MARK: - Expanded Leading
        DynamicIslandExpandedRegion(.leading, priority: dslConfig?.expanded?.leadingPriority ?? 1) {
          if let content = dslConfig?.expanded?.leading {
            renderer.render(content)
              .applyWidgetURL(from: context.attributes.deepLinkUrl)
          } else {
            // Fallback to existing behavior
            dynamicIslandExpandedLeading(title: context.state.title, subtitle: context.state.subtitle)
              .dynamicIsland(verticalPlacement: .belowIfTooWide)
              .padding(.leading, 5)
              .applyWidgetURL(from: context.attributes.deepLinkUrl)
          }
        }

        // MARK: - Expanded Trailing
        DynamicIslandExpandedRegion(.trailing, priority: dslConfig?.expanded?.trailingPriority ?? 0) {
          if let content = dslConfig?.expanded?.trailing {
            renderer.render(content)
              .applyWidgetURL(from: context.attributes.deepLinkUrl)
          } else if let imageName = context.state.imageName {
            // Fallback to existing behavior
            dynamicIslandExpandedTrailing(imageName: imageName)
              .padding(.trailing, 5)
              .applyWidgetURL(from: context.attributes.deepLinkUrl)
          }
        }

        // MARK: - Expanded Center
        DynamicIslandExpandedRegion(.center) {
          if let content = dslConfig?.expanded?.center {
            renderer.render(content)
              .applyWidgetURL(from: context.attributes.deepLinkUrl)
          }
          // No fallback - center region is new
        }

        // MARK: - Expanded Bottom
        DynamicIslandExpandedRegion(.bottom) {
          if let content = dslConfig?.expanded?.bottom {
            renderer.render(content)
              .applyWidgetURL(from: context.attributes.deepLinkUrl)
          } else if let date = context.state.timerEndDateInMilliseconds {
            // Fallback to existing behavior
            dynamicIslandExpandedBottom(
              endDate: date, progressViewTint: context.attributes.progressViewTint
            )
            .padding(.horizontal, 5)
            .applyWidgetURL(from: context.attributes.deepLinkUrl)
          }
        }
      } compactLeading: {
        // MARK: - Compact Leading
        if let content = dslConfig?.compact?.leading {
          renderer.render(content)
            .applyWidgetURL(from: context.attributes.deepLinkUrl)
        } else if let dynamicIslandImageName = context.state.dynamicIslandImageName {
          // Fallback to existing behavior
          resizableImage(imageName: dynamicIslandImageName)
            .frame(maxWidth: 23, maxHeight: 23)
            .applyWidgetURL(from: context.attributes.deepLinkUrl)
        }
      } compactTrailing: {
        // MARK: - Compact Trailing
        if let content = dslConfig?.compact?.trailing {
          renderer.render(content)
            .applyWidgetURL(from: context.attributes.deepLinkUrl)
        } else if let date = context.state.timerEndDateInMilliseconds {
          // Fallback to existing behavior
          compactTimer(
            endDate: date,
            timerType: context.attributes.timerType ?? .circular,
            progressViewTint: context.attributes.progressViewTint
          ).applyWidgetURL(from: context.attributes.deepLinkUrl)
        }
      } minimal: {
        // MARK: - Minimal
        if let content = dslConfig?.minimal?.content {
          renderer.render(content)
            .applyWidgetURL(from: context.attributes.deepLinkUrl)
        } else if let date = context.state.timerEndDateInMilliseconds {
          // Fallback to existing behavior
          compactTimer(
            endDate: date,
            timerType: context.attributes.timerType ?? .circular,
            progressViewTint: context.attributes.progressViewTint
          ).applyWidgetURL(from: context.attributes.deepLinkUrl)
        }
      }
    }
  }

  public init() {}

  @ViewBuilder
  private func compactTimer(
    endDate: Double,
    timerType: LiveActivityAttributes.DynamicIslandTimerType,
    progressViewTint: String?
  ) -> some View {
    if timerType == .digital {
      Text(timerInterval: Date.toTimerInterval(miliseconds: endDate))
        .font(.system(size: 15))
        .minimumScaleFactor(0.8)
        .fontWeight(.semibold)
        .frame(maxWidth: 60)
        .multilineTextAlignment(.trailing)
    } else {
      circularTimer(endDate: endDate)
        .tint(progressViewTint.map { Color(hex: $0) })
    }
  }

  private func dynamicIslandExpandedLeading(title: String, subtitle: String?) -> some View {
    VStack(alignment: .leading) {
      Spacer()
      Text(title)
        .font(.title2)
        .foregroundStyle(.white)
        .fontWeight(.semibold)
      if let subtitle {
        Text(subtitle)
          .font(.title3)
          .minimumScaleFactor(0.8)
          .foregroundStyle(.white.opacity(0.75))
      }
      Spacer()
    }
  }

  private func dynamicIslandExpandedTrailing(imageName: String) -> some View {
    VStack {
      Spacer()
      resizableImage(imageName: imageName)
      Spacer()
    }
  }

  private func dynamicIslandExpandedBottom(endDate: Double, progressViewTint: String?) -> some View {
    ProgressView(timerInterval: Date.toTimerInterval(miliseconds: endDate))
      .foregroundStyle(.white)
      .tint(progressViewTint.map { Color(hex: $0) })
      .padding(.top, 5)
  }

  private func circularTimer(endDate: Double) -> some View {
    ProgressView(
      timerInterval: Date.toTimerInterval(miliseconds: endDate),
      countsDown: false,
      label: { EmptyView() },
      currentValueLabel: {
        EmptyView()
      }
    )
    .progressViewStyle(.circular)
  }
}
