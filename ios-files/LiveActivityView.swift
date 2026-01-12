import SwiftUI
import WidgetKit

#if canImport(ActivityKit)
import ActivityKit

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

  struct DebugLog: View {
    #if DEBUG
      private let message: String
      init(_ message: String) {
        self.message = message
        print(message)
      }

      var body: some View {
        Text(message)
          .font(.caption2)
          .foregroundStyle(.red)
      }
    #else
      init(_: String) {}
      var body: some View { EmptyView() }
    #endif
  }

  struct LiveActivityView: View {
    let contentState: LiveActivityAttributes.ContentState
    let attributes: LiveActivityAttributes
    @State private var imageContainerSize: CGSize?

    var progressViewTint: Color? {
      attributes.progressViewTint.map { Color(hex: $0) }
    }

    private var imageVerticalAlignment: VerticalAlignment {
      switch attributes.imageAlign {
      case "center":
        return .center
      case "bottom":
        return .bottom
      default:
        return .top
      }
    }

    private func alignedImage(imageName: String, horizontalAlignment: HorizontalAlignment) -> some View {
      let defaultHeight: CGFloat = 64
      let defaultWidth: CGFloat = 64
      let containerHeight = imageContainerSize?.height
      let containerWidth = imageContainerSize?.width
      let hasWidthConstraint = (attributes.imageWidthPercent != nil) || (attributes.imageWidth != nil)

      let computedHeight: CGFloat? = {
        if let percent = attributes.imageHeightPercent {
          let clamped = min(max(percent, 0), 100) / 100.0
          // Use the row height as a base. Fallback to default when row height is not measured yet.
          let base = (containerHeight ?? defaultHeight)
          return base * clamped
        } else if let size = attributes.imageHeight {
          return CGFloat(size)
        } else if hasWidthConstraint {
          // Mimic CSS: when only width is set, keep height automatic to preserve aspect ratio
          return nil
        } else {
          // Mimic CSS: this works against CSS but provides a better default behavior.
          // When no width/height is set, use a default size (64pt)
          // Width will adjust automatically base on aspect ratio
          return defaultHeight
        }
      }()

      let computedWidth: CGFloat? = {
        if let percent = attributes.imageWidthPercent {
          let clamped = min(max(percent, 0), 100) / 100.0
          let base = (containerWidth ?? defaultWidth)
          return base * clamped
        } else if let size = attributes.imageWidth {
          return CGFloat(size)
        } else {
          return nil // Keep aspect fit based on height
        }
      }()

      return ZStack(alignment: .center) {
        Group {
          let fit = attributes.contentFit ?? "contain"
          switch fit {
          case "contain":
            Image.dynamic(assetNameOrPath: imageName).resizable().scaledToFit().frame(width: computedWidth, height: computedHeight)
          case "fill":
            Image.dynamic(assetNameOrPath: imageName).resizable().frame(
              width: computedWidth,
              height: computedHeight
            )
          case "none":
            Image.dynamic(assetNameOrPath: imageName).renderingMode(.original).frame(width: computedWidth, height: computedHeight)
          case "scale-down":
            if let uiImage = UIImage.dynamic(assetNameOrPath: imageName) {
              // Determine the target box. When width/height are nil, we use image's intrinsic dimension for comparison.
              let targetHeight = computedHeight ?? uiImage.size.height
              let targetWidth = computedWidth ?? uiImage.size.width
              let shouldScaleDown = uiImage.size.height > targetHeight || uiImage.size.width > targetWidth

              if shouldScaleDown {
                Image(uiImage: uiImage)
                  .resizable()
                  .scaledToFit()
                  .frame(width: computedWidth, height: computedHeight)
              } else {
                Image(uiImage: uiImage)
                  .renderingMode(.original)
                  .frame(width: min(uiImage.size.width, targetWidth), height: min(uiImage.size.height, targetHeight))
              }
            } else {
              DebugLog("⚠️[ExpoLiveActivity] assetNameOrPath couldn't resolve to UIImage")
            }
          case "cover":
            Image.dynamic(assetNameOrPath: imageName).resizable().scaledToFill().frame(
              width: computedWidth,
              height: computedHeight
            ).clipped()
          default:
            DebugLog("⚠️[ExpoLiveActivity] Unknown contentFit '\(fit)'")
          }
        }
      }
      .frame(
        maxWidth: .infinity,
        maxHeight: .infinity,
        alignment: Alignment(horizontal: horizontalAlignment, vertical: imageVerticalAlignment)
      )
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
      if #available(iOS 18.0, *) {
        LiveActivityView_iOS18(
          contentState: contentState,
          attributes: attributes,
          imageContainerSize: $imageContainerSize,
          smallView: { smallView },
          mediumView: { mediumView }
        )
      } else {
        // iOS 17: missing activityFamily in environment -> default to medium
        mediumView
      }
    }

    // Small View (Apple Watch)
    @ViewBuilder
    private var smallView: some View {
      let defaultPadding = 8
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

      VStack(alignment: .leading, spacing: 4) {
        let position = attributes.imagePosition ?? "right"
        let isLeftImage = position.hasPrefix("left")
        let hasImage = contentState.imageName != nil
        let isProgressBarDisplayed = contentState.progress != nil || (contentState.timerEndDateInMilliseconds != nil && contentState.subtitle == nil)
        let isTimerDisplayed = contentState.timerEndDateInMilliseconds != nil

        let isSubtitleDisplayed = contentState.subtitle != nil

        VStack(alignment: .leading, spacing: isProgressBarDisplayed ? 0 : nil) {

          HStack(alignment: .center, spacing: 8) {

            if hasImage, isLeftImage {
              if let imageName = contentState.imageName {
                alignedImage(imageName: imageName, horizontalAlignment: .leading)
                .frame(width: 41, height: 41)
                .layoutPriority(0)
              }
            }

            VStack(alignment: .leading, spacing: 0) {
              Text(contentState.title)
                .font(.system(size: isSubtitleDisplayed ? 13 : 16, weight: .semibold))
                .lineLimit(1)
                .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))

              if let subtitle = contentState.subtitle {
                Text(subtitle)
                  .font(.system(size: 13, weight: .semibold))
                  .lineLimit(1)
                  .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))
              }

              if let date = contentState.timerEndDateInMilliseconds {
                smallTimer(endDate: date, isSubtitleDisplayed: isSubtitleDisplayed)
              }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .layoutPriority(1)

            if hasImage, !isLeftImage {
              if let imageName = contentState.imageName {
                alignedImage(imageName: imageName, horizontalAlignment: .trailing)
                .frame(width: 41, height: 41)
                .layoutPriority(0)
              }
            }
          }

          if let progress = contentState.progress {
            styledLinearProgressView {
              ProgressView(value: progress)
            }
          } else if let date = contentState.timerEndDateInMilliseconds, !isSubtitleDisplayed {
            styledLinearProgressView {
              ProgressView(
                timerInterval: Date.toTimerInterval(miliseconds: date),
                countsDown: false,
                label: { EmptyView() },
                currentValueLabel: { EmptyView() }
              )
            }
          }

        }
        .preferredColorScheme(.light)      

            // if hasImage, isLeftImage {
            //   if let imageName = contentState.imageName {
            //     alignedImage(imageName: imageName, horizontalAlignment: .leading)
            //   }
            // }

      }
      .padding(EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing))
      .preferredColorScheme(.light)
    }

    // Medium View (Lock Screen)
    @ViewBuilder
    private var mediumView: some View {
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
              alignedImage(imageName: imageName, horizontalAlignment: .leading)
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
          }.layoutPriority(1)

          if hasImage, !isLeftImage {
            if let imageName = contentState.imageName {
              alignedImage(imageName: imageName, horizontalAlignment: .trailing)
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

    // MARK: - Small View Helpers
    @ViewBuilder
    private func styledLinearProgressView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
      content()
        .progressViewStyle(.linear)
        .frame(height: 15)
        .scaleEffect(x: 1, y: 2, anchor: .center)
        .tint(progressViewTint)
        .modifier(ConditionalForegroundViewModifier(color: attributes.progressViewLabelColor))
    }

    @ViewBuilder
    private func smallTimer(endDate: Double, isSubtitleDisplayed: Bool) -> some View {

        Text(timerInterval: Date.toTimerInterval(miliseconds: endDate))
          .font(.system(size: isSubtitleDisplayed ? 13 : 16, weight: .medium))
          .modifier(ConditionalForegroundViewModifier(color: attributes.progressViewLabelColor))
          .padding(.top, isSubtitleDisplayed ? 3 : 0)
      
    }
  }

  @available(iOS 18.0, *)
  private struct LiveActivityView_iOS18<Small: View, Medium: View>: View {
    let contentState: LiveActivityAttributes.ContentState
    let attributes: LiveActivityAttributes
    @Binding var imageContainerSize: CGSize?

    let smallView: () -> Small
    let mediumView: () -> Medium

    @Environment(\.activityFamily) private var activityFamily

    var body: some View {
      switch activityFamily {
      case .small:
        smallView()
      case .medium:
        mediumView()
      @unknown default:
        mediumView()
      }
    }
  }

#endif
