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

    public init(
      title: String,
      subtitle: String? = nil,
      timerEndDateInMilliseconds: Double? = nil,
      progress: Double? = nil,
      imageName: String? = nil,
      dynamicIslandImageName: String? = nil
    ) {
      self.title = title
      self.subtitle = subtitle
      self.timerEndDateInMilliseconds = timerEndDateInMilliseconds
      self.progress = progress
      self.imageName = imageName
      self.dynamicIslandImageName = dynamicIslandImageName
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
    contentFit: String? = nil
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
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading, priority: 1) {
          dynamicIslandExpandedLeading(title: context.state.title, subtitle: context.state.subtitle)
            .dynamicIsland(verticalPlacement: .belowIfTooWide)
            .padding(.leading, 5)
            .applyWidgetURL(from: context.attributes.deepLinkUrl)
        }
        DynamicIslandExpandedRegion(.trailing) {
          if let imageName = context.state.imageName {
            dynamicIslandExpandedTrailing(imageName: imageName)
              .padding(.trailing, 5)
              .applyWidgetURL(from: context.attributes.deepLinkUrl)
          }
        }
        DynamicIslandExpandedRegion(.bottom) {
          if let date = context.state.timerEndDateInMilliseconds {
            dynamicIslandExpandedBottom(
              endDate: date, progressViewTint: context.attributes.progressViewTint
            )
            .padding(.horizontal, 5)
            .applyWidgetURL(from: context.attributes.deepLinkUrl)
          }
        }
      } compactLeading: {
        if let dynamicIslandImageName = context.state.dynamicIslandImageName {
          resizableImage(imageName: dynamicIslandImageName)
            .frame(maxWidth: 23, maxHeight: 23)
            .applyWidgetURL(from: context.attributes.deepLinkUrl)
        }
      } compactTrailing: {
        if let date = context.state.timerEndDateInMilliseconds {
          compactTimer(
            endDate: date,
            timerType: context.attributes.timerType ?? .circular,
            progressViewTint: context.attributes.progressViewTint
          ).applyWidgetURL(from: context.attributes.deepLinkUrl)
        }
      } minimal: {
        if let date = context.state.timerEndDateInMilliseconds {
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
