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

    private var hasImage: Bool {
      contentState.imageName != nil
    }

    private var isLeftImage: Bool {
      (attributes.imagePosition ?? "right").hasPrefix("left")
    }

    private var isStretch: Bool {
      (attributes.imagePosition ?? "right").contains("Stretch")
    }

    private func alignedImage(imageName: String, horizontalAlignment: HorizontalAlignment, smallView: Bool = false) -> some View {
      let defaultHeight: CGFloat = smallView ? 28 : 64
      let defaultWidth: CGFloat = smallView ? 28 : 64
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
          // When no width/height is set, use a default size (64 / 28pt)
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

      let resolvedHeight = computedHeight ?? defaultHeight

      let resolvedWidth: CGFloat? = {
        if let w = computedWidth { return w }

        if let uiImage = UIImage.dynamic(assetNameOrPath: imageName) {
          let h = max(uiImage.size.height, 1)
          let ratio = uiImage.size.width / h
          return resolvedHeight * ratio
        }

        return nil
      }()

      return ZStack(alignment: .center) {
        Group {
          let fit = attributes.contentFit ?? "contain"
          switch fit {
          case "contain":
            Image.dynamic(assetNameOrPath: imageName).resizable().scaledToFit().frame(width: resolvedWidth, height: resolvedHeight)
          case "fill":
            Image.dynamic(assetNameOrPath: imageName).resizable().frame(
              width: resolvedWidth,
              height: resolvedHeight
            )
          case "none":
            Image.dynamic(assetNameOrPath: imageName).renderingMode(.original).frame(width: resolvedWidth, height: resolvedHeight)
          case "scale-down":
            if let uiImage = UIImage.dynamic(assetNameOrPath: imageName) {
              // Determine the target box. When width/height are nil, we use image's intrinsic dimension for comparison.
              let targetHeight = resolvedHeight
              let targetWidth = resolvedWidth ?? uiImage.size.width
              let shouldScaleDown = uiImage.size.height > targetHeight || uiImage.size.width > targetWidth

              if shouldScaleDown {
                Image(uiImage: uiImage)
                  .resizable()
                  .scaledToFit()
                  .frame(width: resolvedWidth, height: resolvedHeight)
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
              width: resolvedWidth,
              height: resolvedHeight
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
      let padding = resolvedPadding(defaultPadding: 8)

      VStack(alignment: .leading, spacing: 4) {
        let isSubtitleDisplayed = contentState.subtitle != nil
        let isTimerShownAsText = attributes.timerType == .digital && contentState.timerEndDateInMilliseconds != nil
        let isProgressBarDisplayed = contentState.progress != nil || (contentState.timerEndDateInMilliseconds != nil && !isSubtitleDisplayed && !isTimerShownAsText)

        VStack(alignment: .leading, spacing: isProgressBarDisplayed ? 0 : nil) {
          HStack(alignment: .center, spacing: 8) {
            if hasImage, isLeftImage, !isTimerShownAsText {
              if let imageName = contentState.imageName {
                alignedImage(imageName: imageName, horizontalAlignment: .leading, smallView: true)
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

              if let date = contentState.timerEndDateInMilliseconds, !isTimerShownAsText {
                smallTimer(endDate: date, isSubtitleDisplayed: isSubtitleDisplayed)
              }
            }
            .layoutPriority(1)

            if hasImage, !isLeftImage, !isTimerShownAsText {
              if let imageName = contentState.imageName {
                alignedImage(imageName: imageName, horizontalAlignment: .trailing, smallView: true)
              }
            }
          }

          if isTimerShownAsText, let date = contentState.timerEndDateInMilliseconds {
            HStack {
              if let imageName = contentState.imageName, hasImage, isLeftImage {
                Image.dynamic(assetNameOrPath: imageName)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 23, height: 23)
                  .layoutPriority(0)
                Spacer()
              }
              smallTimer(endDate: date, isSubtitleDisplayed: false).frame(maxWidth: .infinity, alignment: isLeftImage ? .trailing : .leading)
              if let imageName = contentState.imageName, hasImage, !isLeftImage {
                Spacer()
                Image.dynamic(assetNameOrPath: imageName)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 23, height: 23)
                  .layoutPriority(0)
              }
            }
            .frame(maxWidth: .infinity)
          } else {
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
        }
      }
      .padding(padding)
    }

    // Medium View (Lock Screen)
    @ViewBuilder
    private var mediumView: some View {
      let padding = resolvedPadding(defaultPadding: 24)

      VStack(alignment: .leading) {
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
      .padding(padding)
    }

    private func resolvedPadding(defaultPadding: Int) -> EdgeInsets {
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
      return EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }

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
