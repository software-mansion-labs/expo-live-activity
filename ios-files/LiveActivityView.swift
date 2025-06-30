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
  let attributes: LiveActivityAttributes
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .center) {
        VStack(alignment: .leading, spacing: 2) {
          Text(contentState.title)
            .font(.title2)
            .foregroundStyle(Color(hex: attributes.titleColor))
            .fontWeight(.semibold)
          Text(contentState.subtitle)
            .font(.title3)
            .foregroundStyle(Color(hex: attributes.subtitleColor))
        }
        
        Spacer()
        
        Image(contentState.imageName)
          .resizable()
          .scaledToFit()
          .frame(width: 64, height: 64)
      }
      .padding(.bottom, 16)
      
      if let date = contentState.date {
        ProgressView(timerInterval: Date.now...max(Date.now, date))
          .tint(Color(hex: attributes.progressViewTint))
          .foregroundStyle(Color(hex: attributes.progressViewLabelColor))
      }
    }
    .padding(24)
  }
}

#endif
