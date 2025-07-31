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
    var date: Double?
    var imageName: String?
    var dynamicIslandImageName: String?
  }

  var name: String
  var backgroundColor: String?
  var titleColor: String?
  var subtitleColor: String?
  var progressViewTint: String?
  var progressViewLabelColor: String?
  var timerType: DynamicIslandTimerType

  enum DynamicIslandTimerType: String, Codable {
    case circular
    case digital
  }
}

func createTimerInterval(date: Double) -> ClosedRange<Date> {
  return Date.now...max(Date.now, Date(timeIntervalSince1970: date / 1000))
}

struct LiveActivityWidget: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivityAttributes.self) { context in
      LiveActivityView(contentState: context.state, attributes: context.attributes)
        .activityBackgroundTint(
          context.attributes.backgroundColor != nil ? Color(hex: context.attributes.backgroundColor!) : nil
        )
        .activitySystemActionForegroundColor(Color.black)

    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading, priority: 1) {
          dynamicIslandExpandedLeading(title: context.state.title, subtitle: context.state.subtitle)
            .dynamicIsland(verticalPlacement: .belowIfTooWide)
            .padding(.leading, 5)
        }
        DynamicIslandExpandedRegion(.trailing) {
          if let imageName = context.state.imageName {
            dynamicIslandExpandedTrailing(imageName: imageName)
              .padding(.trailing, 5)
          }
        }
        DynamicIslandExpandedRegion(.bottom) {
          if let date = context.state.date {
            dynamicIslandExpandedBottom(endDate: date, progressViewTint: context.attributes.progressViewTint)
              .padding(.horizontal, 5)
          }
        }
      } compactLeading: {
        if let dynamicIslandImageName = context.state.dynamicIslandImageName {
          resizableImage(imageName: dynamicIslandImageName)
            .frame(maxWidth: 23, maxHeight: 23)
        }
      } compactTrailing: {
        if let date = context.state.date {
          compactTimer(
            endDate: date,
            timerType: context.attributes.timerType,
            progressViewTint: context.attributes.progressViewTint
          )
        }
      } minimal: {
        if let date = context.state.date {
          compactTimer(
            endDate: date,
            timerType: context.attributes.timerType,
            progressViewTint: context.attributes.progressViewTint
          )
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
      Text(timerInterval: createTimerInterval(date: endDate))
        .font(.system(size: 15))
        .minimumScaleFactor(0.8)
        .fontWeight(.semibold)
        .frame(maxWidth: 60)
        .multilineTextAlignment(.trailing)
    } else {
      circularTimer(endDate: endDate)
        .tint(progressViewTint != nil ? Color(hex: progressViewTint!) : nil)
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
    ProgressView(timerInterval: createTimerInterval(date: endDate))
      .foregroundStyle(.white)
      .tint(progressViewTint != nil ? Color(hex: progressViewTint!) : nil)
      .padding(.top, 5)
  }

  private func circularTimer(endDate: Double) -> some View {
    ProgressView(
      timerInterval: createTimerInterval(date: endDate),
      countsDown: false,
      label: { EmptyView() },
      currentValueLabel: {
        EmptyView()
      }
    )
    .progressViewStyle(.circular)
  }
  private func resizableImage(imageName: String) -> some View {
    Image(imageName)
      .resizable()
      .scaledToFit()
  }
}
