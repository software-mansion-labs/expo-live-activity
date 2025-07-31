//
//  LiveActivityView.swift
//  ExpoLiveActivity
//
//  Created by Anna Olak on 03/06/2025.
//

import SwiftUI
import WidgetKit

#if canImport(ActivityKit)

  struct ConditionalForegroundViewModifier: ViewModifier {
    let color: String?

    func body(content: Content) -> some View {
      if let color = color {
        content.foregroundStyle(Color(hex: color))
      } else {
        content
      }
    }
  }

  struct LiveActivityView: View {
    let contentState: LiveActivityAttributes.ContentState
    let attributes: LiveActivityAttributes

    var progressViewTint: Color? {
      attributes.progressViewTint.map { Color(hex: $0) }
    }

    var body: some View {
      VStack(alignment: .leading) {
        HStack(alignment: .center) {
          VStack(alignment: .leading, spacing: 2) {
            Text(contentState.title)
              .font(.title2)
              .fontWeight(.semibold)
              .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))

            if let subtitle = contentState.subtitle {
              Text(subtitle)
                .font(.title3)
                .modifier(ConditionalForegroundViewModifier(color: attributes.subtitleColor))
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
          ProgressView(timerInterval: createTimerInterval(date: date))
            .tint(progressViewTint)
            .modifier(ConditionalForegroundViewModifier(color: attributes.progressViewLabelColor))
        }
      }
      .padding(24)
    }
  }

#endif
