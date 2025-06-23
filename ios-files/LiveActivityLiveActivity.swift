//
//  LiveActivityLiveActivity.swift
//  LiveActivity
//
//  Created by Anna Olak on 02/06/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LiveActivityAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var title: String
    var subtitle: String
    var date: Date
    var imageName: String
  }
  
  var name: String
}

struct LiveActivityLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivityAttributes.self) { context in
      LiveActivityView(contentState: context.state)
        .activityBackgroundTint(Color.cyan)
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
      ProgressView(timerInterval: Date.now...endDate)
    }
    .padding(.bottom, 5)
  }    
  private func circularTimer(endDate: Date) -> some View {
    ProgressView(
      timerInterval: Date.now...endDate,
      countsDown: false,
      label: { EmptyView() },
      currentValueLabel: {
        EmptyView()
      })
    .progressViewStyle(.circular)
  }
  private func resizableImage(imageName: String) -> some View {
    Image(imageName)
      .resizable()
      .scaledToFit()
  }
}
