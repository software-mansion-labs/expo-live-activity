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
      let defaultPadding = 24

      let top = CGFloat(
        attributes.paddingConfig?.top
          ?? attributes.paddingConfig?.vertical
          ?? attributes.padding
          ?? defaultPadding
      )

      let bottom = CGFloat(
        attributes.paddingConfig?.bottom
          ?? attributes.paddingConfig?.vertical
          ?? attributes.padding
          ?? defaultPadding
      )

      let leading = CGFloat(
        attributes.paddingConfig?.left
          ?? attributes.paddingConfig?.horizontal
          ?? attributes.padding
          ?? defaultPadding
      )

      let trailing = CGFloat(
        attributes.paddingConfig?.right
          ?? attributes.paddingConfig?.horizontal
          ?? attributes.padding
          ?? defaultPadding
      )

      VStack(alignment: .leading) {
        HStack(alignment: .center) {
          if attributes.imagePosition == "left" {
            if let imageName = contentState.imageName {
              resizableImage(imageName: imageName)
                .applyImageSize(attributes.imageSize)
              Spacer()
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
            Spacer()
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
      .padding(EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing))
    }
  }

#endif
