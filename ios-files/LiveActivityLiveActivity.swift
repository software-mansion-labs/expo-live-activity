//
//  LiveActivityLiveActivity.swift
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
    var subtitle: String
    var date: Date?
    var imageName: String
    var dynamicIslandImageName: String
  }

  var name: String
  var backgroundColor: String
  var titleColor: String
  var subtitleColor: String
  var progressViewTint: String
  var progressViewLabelColor: String
  var timeAsText: Bool
}

struct LiveActivityLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivityAttributes.self) { context in
      LiveActivityView(contentState: context.state, attributes: context.attributes)
        .activityBackgroundTint(Color(hex: context.attributes.backgroundColor))
        .activitySystemActionForegroundColor(Color.black)

    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading, priority: 1) {
          dynamicIslandExpandedLeading(title: context.state.title, subtitle: context.state.subtitle)
            .dynamicIsland(verticalPlacement: .belowIfTooWide)
        }
        DynamicIslandExpandedRegion(.trailing) {
          dynamicIslandExpandedTrailing(imageName: context.state.imageName)
          
        }
        DynamicIslandExpandedRegion(.bottom) {
          if let date = context.state.date {
            dynamicIslandExpandedBottom(endDate: date, progressViewTint: context.attributes.progressViewTint)
          }
        }
      } compactLeading: {
        resizableImage(imageName: context.state.dynamicIslandImageName)
          .frame(maxWidth: 23, maxHeight: 23)
      } compactTrailing: {
        if let date = context.state.date {
          compactTimer(endDate: date, timerAsText: context.attributes.timeAsText, progressViewTint: context.attributes.progressViewTint)
        }
      } minimal: {
        if let date = context.state.date {
          compactTimer(endDate: date, timerAsText: context.attributes.timeAsText, progressViewTint: context.attributes.progressViewTint)
        }
      }
    }
  }
  
  @ViewBuilder
  private func compactTimer(endDate: Date, timerAsText: Bool, progressViewTint: String) -> some View {
      if timerAsText {
        Text(timerInterval: Date.now...max(Date.now, endDate))
          .font(.system(size: 15))
          .fontWeight(.semibold)
          .frame(maxWidth: 60)
          .multilineTextAlignment(.trailing)
      } else {
        circularTimer(endDate: endDate)
          .tint(Color(hex: progressViewTint))
      }
  }

  private func dynamicIslandExpandedLeading(title: String, subtitle: String) -> some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.title2)
        .foregroundStyle(.white)
        .fontWeight(.semibold)
      Text(subtitle)
        .font(.title3)
        .minimumScaleFactor(0.8)
        .foregroundStyle(.white.opacity(0.75))
    }
  }
  
  private func dynamicIslandExpandedTrailing(imageName: String) -> some View {
    VStack {
      Spacer()
      resizableImage(imageName: imageName)
        .frame(width: 64, height: 64)
      Spacer()
    }
  }
  
  private func dynamicIslandExpandedBottom(endDate: Date, progressViewTint: String) -> some View {
    ProgressView(timerInterval: Date.now...max(Date.now, endDate))
      .padding(.bottom, 5)
      .foregroundStyle(.white)
      .tint(Color(hex: progressViewTint))
  }
  private func circularTimer(endDate: Date) -> some View {
    ProgressView(
      timerInterval: Date.now...max(Date.now, endDate),
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

extension Color {
    init(hex: String) {
      var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

      if (cString.hasPrefix("#")) {
          cString.remove(at: cString.startIndex)
      }

      if ((cString.count) != 6 && (cString.count) != 8) {
        self.init(.white)
        return
      }

      var rgbValue: UInt64 = 0
      Scanner(string: cString).scanHexInt64(&rgbValue)
      
      if ((cString.count) == 8) {
        self.init(
          .sRGB,
          red: Double((rgbValue >> 24) & 0xff) / 255,
          green: Double((rgbValue >> 16) & 0xff) / 255,
          blue: Double((rgbValue >> 08) & 0xff) / 255,
          opacity: Double((rgbValue >> 00) & 0xff) / 255,
        )
      } else {
        self.init(
          .sRGB,
          red: Double((rgbValue >> 16) & 0xff) / 255,
          green: Double((rgbValue >> 08) & 0xff) / 255,
          blue: Double((rgbValue >> 00) & 0xff) / 255,
          opacity: 1
        )
      }
    }
}
