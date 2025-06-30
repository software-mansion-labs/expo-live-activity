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
    var date: Date
    var imageName: String
  }

  var name: String
  var backgroundColor: String
  var titleColor: String
  var subtitleColor: String
  var progressViewTint: String
  var progressViewLabelColor: String
}

struct LiveActivityLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivityAttributes.self) { context in
      LiveActivityView(contentState: context.state, attributes: context.attributes)
        .activityBackgroundTint(Color(hex: context.attributes.backgroundColor))
        .activitySystemActionForegroundColor(Color.black)

    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          dynamicIslandExpandedLeading(title: context.state.title)
        }
        DynamicIslandExpandedRegion(.trailing) {
          resizableImage(imageName: context.state.imageName)
        }
        DynamicIslandExpandedRegion(.bottom) {
          dynamicIslandExpandedBottom(subtitle: context.state.subtitle, endDate: context.state.date)
        }
      } compactLeading: {
        resizableImage(imageName: context.state.imageName)
      } compactTrailing: {
        circularTimer(endDate: context.state.date)
      } minimal: {
        circularTimer(endDate: context.state.date)
      }
    }
  }

  private func dynamicIslandExpandedLeading(title: String) -> some View {
    VStack {
      Text(title)
        .font(.title3)
    }
    .padding(.top, 5)
  }
  private func dynamicIslandExpandedTrailing(imageName: String) -> some View {
    Image(imageName)
      .resizable()
      .scaledToFit()
  }
  private func dynamicIslandExpandedBottom(subtitle: String, endDate: Date) -> some View {
    VStack {
      HStack {
        Text(subtitle)
        Spacer()
      }
      ProgressView(timerInterval: Date.now...max(Date.now, endDate))
    }
    .padding(.bottom, 5)
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
