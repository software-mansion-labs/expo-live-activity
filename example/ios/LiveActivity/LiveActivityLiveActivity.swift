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
  }
  
  var name: String
}

struct LiveActivityLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivityAttributes.self) { context in
      // Lock screen/banner UI goes here
      LiveActivityView(contentState: context.state)
        .activityBackgroundTint(Color.cyan.opacity(0.7))
        .activitySystemActionForegroundColor(Color.black)
      
    } dynamicIsland: { context in
      DynamicIsland {
        // Expanded UI goes here.  Compose the expanded UI through
        // various regions, like leading/trailing/center/bottom
        DynamicIslandExpandedRegion(.leading) {
          VStack {
            Text(context.state.title)
              .font(.title3)
          }
          .padding(.top, 5)
        }
        DynamicIslandExpandedRegion(.trailing) {
          Image("cat3")
            .resizable()
            .scaledToFit()
        }
        DynamicIslandExpandedRegion(.bottom) {
          VStack {
            HStack {
              Text(context.state.subtitle)
              Spacer()
            }
            ProgressView(timerInterval: Date.now...context.state.date)
          }
          .padding(.bottom, 5)
        }
      } compactLeading: {
        Image("cat3")
          .resizable()
          .scaledToFit()
      } compactTrailing: {
        //        Text(timerInterval: Date.now...context.state.date)
        //          .frame(width: 40)
        //          .multilineTextAlignment(.trailing)
        ProgressView(
          timerInterval: Date.now...context.state.date,
          countsDown: false,
          label: { EmptyView() },
          currentValueLabel: {
            Text(timerInterval: Date.now...context.state.date)
              .background {
                RoundedRectangle(cornerRadius: 20)
                  .foregroundStyle(.black.opacity(0.8))
              }
          })
        .progressViewStyle(.circular)
      } minimal: {
        ProgressView(
          timerInterval: Date.now...context.state.date,
          countsDown: false,
          label: { EmptyView() },
          currentValueLabel: { EmptyView() }
        )
        .progressViewStyle(.circular)
      }
      .widgetURL(URL(string: "http://www.apple.com"))
      .keylineTint(Color.red)
    }
  }
}

extension LiveActivityAttributes {
  fileprivate static var preview: LiveActivityAttributes {
    LiveActivityAttributes(name: "World")
  }
}

extension LiveActivityAttributes.ContentState {
  fileprivate static var smiley: LiveActivityAttributes.ContentState {
    LiveActivityAttributes.ContentState(title: "Title!", subtitle: "This is great.", date: .distantFuture)
  }
  
  fileprivate static var starEyes: LiveActivityAttributes.ContentState {
    LiveActivityAttributes.ContentState(title: "Title!", subtitle: "This is great.", date: .distantFuture)
  }
}

#Preview("Notification", as: .content, using: LiveActivityAttributes.preview) {
  LiveActivityLiveActivity()
} contentStates: {
  LiveActivityAttributes.ContentState.smiley
  //  LiveActivityAttributes.ContentState.starEyes
}
