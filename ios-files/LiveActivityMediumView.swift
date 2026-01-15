import SwiftUI
import WidgetKit

#if canImport(ActivityKit)
  import ActivityKit

  struct LiveActivityMediumView: View {
    let contentState: LiveActivityAttributes.ContentState
    let attributes: LiveActivityAttributes
    @Binding var imageContainerSize: CGSize?
    let alignedImage: (String, HorizontalAlignment, Bool) -> AnyView
 
    private var hasImage: Bool {
      contentState.imageName != nil
    }

    private var isLeftImage: Bool {
      (attributes.imagePosition ?? "right").hasPrefix("left")
    }

    private var isStretch: Bool {
      (attributes.imagePosition ?? "right").contains("Stretch")
    }

    private var effectiveStretch: Bool {
      isStretch && hasImage
    }

    private var progressViewTint: Color? {
      attributes.progressViewTint.map { Color(hex: $0) }
    }

    var body: some View {
      let padding = attributes.resolvedPadding(defaultPadding: 24)


      let hasSegmentedProgress = contentState.currentStep != nil
        && (contentState.totalSteps ?? 0) > 0

      let segmentActiveColor = attributes.progressSegmentActiveColor.map { Color(hex: $0) } ?? Color.blue
      let segmentInactiveColor = attributes.progressSegmentInactiveColor.map { Color(hex: $0) } ?? Color.gray.opacity(0.3)

      #if DEBUG
        if hasSegmentedProgress,
           contentState.elapsedTimerStartDateInMilliseconds != nil
           || contentState.timerEndDateInMilliseconds != nil
           || contentState.progress != nil
        {
          DebugLog("⚠️[ExpoLiveActivity] Both segmented and regular progress provided; showing segmented")
        }
      #endif

      VStack(alignment: .leading) {
        HStack(alignment: .center) {
          if hasImage, isLeftImage {
            if let imageName = contentState.imageName {
              alignedImage(imageName, .leading, false)
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
              if hasSegmentedProgress,
                 let currentStep = contentState.currentStep,
                 let totalSteps = contentState.totalSteps,
                 totalSteps > 0
              {
                SegmentedProgressView(
                  currentStep: currentStep,
                  totalSteps: totalSteps,
                  activeColor: segmentActiveColor,
                  inactiveColor: segmentInactiveColor
                )
              } else if let date = contentState.timerEndDateInMilliseconds {
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
              alignedImage(imageName, .trailing, false)
            }
          }
        }

        if !effectiveStretch {
          if hasSegmentedProgress,
              let currentStep = contentState.currentStep,
              let totalSteps = contentState.totalSteps,
              totalSteps > 0
          {
            SegmentedProgressView(
              currentStep: currentStep,
              totalSteps: totalSteps,
              activeColor: segmentActiveColor,
              inactiveColor: segmentInactiveColor
            )
          } else if let date = contentState.timerEndDateInMilliseconds {
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
  }

#endif
