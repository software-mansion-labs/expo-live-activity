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

    private var edgeInsets: EdgeInsets {
      let defaultPadding: CGFloat = 24

      switch attributes.padding {
      case .number(let n):
        let val = CGFloat(n)
        return EdgeInsets(top: val, leading: val, bottom: val, trailing: val)

      case .values(let v):
        let top = v.top.map { CGFloat($0) }
        ?? v.vertical.map { CGFloat($0) }
        ?? defaultPadding
        let bottom = v.bottom.map { CGFloat($0) }
        ?? v.vertical.map { CGFloat($0) }
        ?? defaultPadding
        let leading = v.left.map { CGFloat($0) }
        ?? v.horizontal.map { CGFloat($0) }
        ?? defaultPadding
        let trailing = v.right.map { CGFloat($0) }
        ?? v.horizontal.map { CGFloat($0) }
        ?? defaultPadding
        return EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)

      case .none:
        return EdgeInsets(
          top: defaultPadding,
          leading: defaultPadding,
          bottom: defaultPadding,
          trailing: defaultPadding
        )
      }
    }

    var body: some View {
      VStack(alignment: .leading) {
        HStack(alignment: .center) {
          if attributes.imagePosition == "left" {
            if let imageName = contentState.imageName {
              resizableImage(imageName: imageName)
              .applyImageSize(attributes.imageSize)
            }
          }

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

            if attributes.imageSize == "fullHeight" {
              if let date = contentState.timerEndDateInMilliseconds {
                ProgressView(timerInterval: Date.toTimerInterval(miliseconds: date))
                .tint(progressViewTint)
                .modifier(ConditionalForegroundViewModifier(color: attributes.progressViewLabelColor))
              } else if let progress = contentState.progress {
                ProgressView(value: progress)
                .tint(progressViewTint)
                .modifier(ConditionalForegroundViewModifier(color: attributes.progressViewLabelColor))
              }
            }
          }

          if attributes.imagePosition == "right" || attributes.imagePosition == nil {
            Spacer();
            if let imageName = contentState.imageName {
              resizableImage(imageName: imageName)
              .applyImageSize(attributes.imageSize)
            }
          }
        }

      if attributes.imageSize != "fullHeight" {
        if let date = contentState.timerEndDateInMilliseconds {
          ProgressView(timerInterval: Date.toTimerInterval(miliseconds: date))
            .tint(progressViewTint)
            .modifier(ConditionalForegroundViewModifier(color: attributes.progressViewLabelColor))
        } else if let progress = contentState.progress {
          ProgressView(value: progress)
            .tint(progressViewTint)
            .modifier(ConditionalForegroundViewModifier(color: attributes.progressViewLabelColor))
          }
        }
      }
      .padding(edgeInsets)
    }
  }

#endif
