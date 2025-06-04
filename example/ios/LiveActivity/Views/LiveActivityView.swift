//
//  LiveActivityView.swift
//  ExpoLiveActivity
//
//  Created by Anna Olak on 03/06/2025.
//

import SwiftUI
import WidgetKit

#if canImport(ActivityKit)

struct LiveActivityView: View {
  let contentState: LiveActivityAttributes.ContentState
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        VStack(alignment: .leading) {
          Text(contentState.title)
            .font(.title2)
          Text("\(contentState.subtitle)")
            .font(.body)
        }
        Spacer()
        Text(contentState.emoji)
      }
      ProgressView(timerInterval: Date.now...contentState.date)
    }
    .padding()
    
  }
}

#endif
