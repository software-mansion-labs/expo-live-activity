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
    @State private var imageContainerSize: CGSize?

    var progressViewTint: Color? {
      attributes.progressViewTint.map { Color(hex: $0) }
    }

    private var imageAlignment: Alignment {
      switch attributes.imageAlign {
      case "center":
        return .center
      case "bottom":
        return .bottom
      default:
        return .top
      }
    }

    private func alignedImage(imageName: String) -> some View {
      let defaultHeight: CGFloat = 64
      let computedHeight = CGFloat(attributes.imageSize ?? Int(defaultHeight))
      let computedWidth: CGFloat? = nil

      return ZStack(alignment: .center) {
        Group {
          let fit = attributes.contentFit ?? "cover"
          switch fit {
          case "contain":
            Image.dynamic(assetNameOrPath: imageName)
              .resizable()
              .scaledToFit()
              .frame(width: computedWidth, height: computedHeight)
          case "fill":
            Image.dynamic(assetNameOrPath: imageName)
              .resizable()
              .frame(
                width: computedWidth,
                height: computedHeight
              )
          case "none":
            Image.dynamic(assetNameOrPath: imageName)
              .renderingMode(.original)
              .frame(width: computedWidth, height: computedHeight)
          case "scale-down":
            Image.dynamic(assetNameOrPath: imageName)
              .resizable()
              .scaledToFit()
              .frame(width: computedWidth, height: computedHeight)
          default: // "cover"
            Image.dynamic(assetNameOrPath: imageName)
              .resizable()
              .scaledToFill()
              .frame(
                width: computedWidth,
                height: computedHeight
              )
              .clipped()
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: imageAlignment)
      .background(
        GeometryReader { proxy in
          Color.clear
            .onAppear {
              let s = proxy.size
              if s.width > 0, s.height > 0 { imageContainerSize = s }
            }
            .onChange(of: proxy.size) { s in
              if s.width > 0, s.height > 0 { imageContainerSize = s }
            }
        }
      )
    }

    var body: some View {
      let defaultPadding = 24

      let top = CGFloat(
        attributes.paddingDetails?.top
          ?? attributes.paddingDetails?.vertical
          ?? attributes.padding
          ?? defaultPadding
      )

      let bottom = CGFloat(
        attributes.paddingDetails?.bottom
          ?? attributes.paddingDetails?.vertical
          ?? attributes.padding
          ?? defaultPadding
      )

      let leading = CGFloat(
        attributes.paddingDetails?.left
          ?? attributes.paddingDetails?.horizontal
          ?? attributes.padding
          ?? defaultPadding
      )

      let trailing = CGFloat(
        attributes.paddingDetails?.right
          ?? attributes.paddingDetails?.horizontal
          ?? attributes.padding
          ?? defaultPadding
      )

      VStack(alignment: .leading) {
        let position = attributes.imagePosition ?? "right"
        let isStretch = position.contains("Stretch")
        let isLeftImage = position.hasPrefix("left")
        let hasImage = contentState.imageName != nil
        let effectiveStretch = isStretch && hasImage

        HStack(alignment: .center) {
          if hasImage, isLeftImage {
            if let imageName = contentState.imageName {
              alignedImage(imageName: imageName)
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

            if effectiveStretch {
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
          .layoutPriority(1)

          if hasImage, !isLeftImage { // right side (default)
            Spacer()
            if let imageName = contentState.imageName {
              alignedImage(imageName: imageName)
            }
          }
        }

        if !effectiveStretch {
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
