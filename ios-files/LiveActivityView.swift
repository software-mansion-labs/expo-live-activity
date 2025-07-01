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
          if let titleColor = attributes.titleColor {
            Text(contentState.title)
              .font(.title2)
              .foregroundStyle(Color(hex: titleColor))
              .fontWeight(.semibold)
          } else {
            Text(contentState.title)
              .font(.title2)
              .fontWeight(.semibold)
          }
          
          if let subtitle = contentState.subtitle {
            if let subtitleColor = attributes.subtitleColor {
              Text(subtitle)
                .font(.title3)
                .foregroundStyle(Color(hex: subtitleColor))
            } else {
              Text(subtitle)
                .font(.title3)
            }
          }
        }
        
        Spacer()
        
        if let imageName = contentState.imageName {  
          Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(maxHeight: 64)
        }
      }
      
      if let date = contentState.date {
        if let progressViewLabelColor = attributes.progressViewLabelColor {
          ProgressView(timerInterval: Date.now...max(Date.now, date))
            .tint(attributes.progressViewTint != nil ? Color(hex: attributes.progressViewTint!) : nil)
            .foregroundStyle(Color(hex: progressViewLabelColor))
        } else {
          ProgressView(timerInterval: Date.now...max(Date.now, date))
            .tint(attributes.progressViewTint != nil ? Color(hex: attributes.progressViewTint!) : nil)
        }
      }
    }
    .padding(24)
  }
}

#endif
