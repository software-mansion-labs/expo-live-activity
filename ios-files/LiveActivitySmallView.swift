import SwiftUI
import WidgetKit

#if canImport(ActivityKit)
  import ActivityKit

  struct LiveActivitySmallView: View {
    let contentState: LiveActivityAttributes.ContentState
    let attributes: LiveActivityAttributes
    @Binding var imageContainerSize: CGSize?
    let alignedImage: (String, HorizontalAlignment, Bool) -> AnyView

    // CarPlay Live Activity views don't have fixed dimensions (unlike Apple Watch),
    // because the system may scale them to fit the vehicle display.
    // These thresholds are derived from the CarPlay live activities test sizes listed in the documentation.
    private let carPlayWidthThreshold: CGFloat = 200
    private let carPlayTallHeightThreshold: CGFloat = 90

    private var hasImage: Bool {
      contentState.imageName != nil
    }

    private var isLeftImage: Bool {
      (attributes.imagePosition ?? "right").hasPrefix("left")
    }

    private var progressViewTint: Color? {
      attributes.progressViewTint.map { Color(hex: $0) }
    }

    private var isSubtitleDisplayed: Bool {
      contentState.subtitle != nil
    }

    private var isTimerShownAsText: Bool {
      attributes.timerType == .digital && contentState.timerEndDateInMilliseconds != nil
    }

    private var shouldShowProgressBar: Bool {
      let hasProgress = contentState.progress != nil
      let hasTimer = contentState.timerEndDateInMilliseconds != nil
      return hasProgress || (hasTimer && !isSubtitleDisplayed && !isTimerShownAsText) || contentState.hasSegmentedProgress
    }

    var body: some View {
      GeometryReader { proxy in
        let w = proxy.size.width
        let h = proxy.size.height

        let carPlayView = w > carPlayWidthThreshold
        let carPlayTallView = carPlayView && h > carPlayTallHeightThreshold

        let padding = attributes.resolvedPadding(defaultPadding: carPlayView ? 14 : 8)

        let fixedImageSize: CGFloat = carPlayView ? 28 : 23

        let _ = contentState.logSegmentedProgressWarningIfNeeded()

        VStack(alignment: .leading, spacing: 4) {
          VStack(alignment: .leading, spacing: shouldShowProgressBar ? 0 : nil) {
            HStack(alignment: .center, spacing: 8) {
              if hasImage, isLeftImage, !isTimerShownAsText, let imageName = contentState.imageName {
                if carPlayView, !carPlayTallView {
                  fixedSizeImage(name: imageName, size: fixedImageSize)
                  Spacer()
                } else {
                  alignedImage(imageName, .leading, true)
                }
              }

              VStack(alignment: .leading, spacing: 0) {
                Text(contentState.title)
                  .font(carPlayView
                    ? (isSubtitleDisplayed || contentState.hasSegmentedProgress ? .body : .footnote)
                    : (isSubtitleDisplayed ? .footnote : .callout))
                  .fontWeight(.semibold)
                  .lineLimit(1)
                  .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))

                if let subtitle = contentState.subtitle, !(carPlayView && !carPlayTallView) {
                  Text(subtitle)
                    .font(carPlayView ? .body : .footnote)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .modifier(ConditionalForegroundViewModifier(color: attributes.subtitleColor))
                }

                if let startDate = contentState.elapsedTimerStartDateInMilliseconds {
                  ElapsedTimerText(
                    startTimeMilliseconds: startDate,
                    color: attributes.progressViewLabelColor.map { Color(hex: $0) }
                  )
                  .font(carPlayView
                    ? (isSubtitleDisplayed ? .footnote : .title2)
                    : (isSubtitleDisplayed ? .footnote : .callout))
                  .fontWeight(carPlayView && !isSubtitleDisplayed ? .semibold : .medium)
                  .padding(.top, isSubtitleDisplayed ? 3 : 0)
                } else if let date = contentState.timerEndDateInMilliseconds, !isTimerShownAsText, !(carPlayView && isSubtitleDisplayed) {
                  smallTimerText(endDate: date, isSubtitleDisplayed: isSubtitleDisplayed, carPlayView: carPlayView, labelColor: attributes.progressViewLabelColor)
                }
              }
              .layoutPriority(1)

              if hasImage, !isLeftImage, !isTimerShownAsText, let imageName = contentState.imageName {
                if carPlayView, !carPlayTallView {
                  Spacer()
                  fixedSizeImage(name: imageName, size: fixedImageSize)
                } else {
                  alignedImage(imageName, .trailing, true)
                }
              }
            }
            if isTimerShownAsText, let date = contentState.timerEndDateInMilliseconds {
              HStack {
                if let imageName = contentState.imageName, hasImage, isLeftImage {
                  fixedSizeImage(name: imageName, size: fixedImageSize)
                  Spacer()
                }
                smallTimerText(endDate: date, isSubtitleDisplayed: false, carPlayView: carPlayView, labelColor: attributes.progressViewLabelColor).frame(maxWidth: .infinity, alignment: isLeftImage ? .trailing : .leading)
                if let imageName = contentState.imageName, hasImage, !isLeftImage {
                  Spacer()
                  fixedSizeImage(name: imageName, size: fixedImageSize)
                }
              }
              .frame(maxWidth: .infinity)
            } else {
              if contentState.hasSegmentedProgress,
                 let currentStep = contentState.currentStep,
                 let totalSteps = contentState.totalSteps,
                 totalSteps > 0
              {
                SegmentedProgressView(
                  currentStep: currentStep,
                  totalSteps: totalSteps,
                  activeColor: attributes.segmentActiveColor,
                  inactiveColor: attributes.segmentInactiveColor,
                  height: 6
                ).padding(.bottom, 6)
              } else if let progress = contentState.progress {
                styledLinearProgressView(tint: progressViewTint, labelColor: attributes.progressViewLabelColor) {
                  ProgressView(value: progress)
                }
              } else if let date = contentState.timerEndDateInMilliseconds, !isSubtitleDisplayed || carPlayView {
                HStack(spacing: 4) {
                  styledLinearProgressView(tint: progressViewTint, labelColor: attributes.progressViewLabelColor) {
                    ProgressView(
                      timerInterval: Date.toTimerInterval(miliseconds: date),
                      countsDown: false,
                      label: { EmptyView() },
                      currentValueLabel: { EmptyView() }
                    )
                  }
                  .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                  if carPlayView, isSubtitleDisplayed {
                    Text(timerInterval: Date.toTimerInterval(miliseconds: date))
                      .font(.footnote)
                      .monospacedDigit()
                      .lineLimit(1)
                      .modifier(ConditionalForegroundViewModifier(color: attributes.progressViewLabelColor))
                      .multilineTextAlignment(.trailing)
                      .frame(maxWidth: 60, alignment: .trailing)
                  }
                }
              }
            }
          }
        }
        .padding(padding)
      }
    }
  }

#endif
