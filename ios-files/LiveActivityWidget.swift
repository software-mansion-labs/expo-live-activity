//
//  LiveActivityWidget.swift
//  LiveActivity
//
//  Created by Anna Olak on 02/06/2025.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct LiveActivityAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var title: String
    var subtitle: String?
    var timerEndDateInMilliseconds: Double?
    var progress: Double?
    var imageName: String?
    var dynamicIslandImageName: String?
  }

  var name: String
  var backgroundColor: String?
  var titleColor: String?
  var subtitleColor: String?
  var progressViewTint: String?
  var progressViewLabelColor: String?
  var deepLinkUrl: String?
  var timerType: DynamicIslandTimerType?

  enum DynamicIslandTimerType: String, Codable {
    case circular
    case digital
  }
}

struct LiveActivityWidget: Widget {
  var body: some WidgetConfiguration {
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
            dynamicIslandExpandedBottom(endDate: date, progressViewTint: context.attributes.progressViewTint)
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
        .frame(maxHeight: 64)
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
