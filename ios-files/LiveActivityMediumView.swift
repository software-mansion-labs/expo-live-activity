import SwiftUI
import WidgetKit

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

    let _ = contentState.logSegmentedProgressWarningIfNeeded()

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
            if contentState.hasSegmentedProgress,
               let currentStep = contentState.currentStep,
               let totalSteps = contentState.totalSteps,
               totalSteps > 0
            {
              SegmentedProgressView(
                currentStep: currentStep,
                totalSteps: totalSteps,
                activeColor: attributes.segmentActiveColor,
                inactiveColor: attributes.segmentInactiveColor
              )
            } else if let startDate = contentState.elapsedTimerStartDateInMilliseconds {
              ElapsedTimerText(
                startTimeMilliseconds: startDate,
                color: attributes.progressViewLabelColor.map { Color(hex: $0) }
              )
              .font(.title3)
              .fontWeight(.medium)
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
        if contentState.hasSegmentedProgress,
           let currentStep = contentState.currentStep,
           let totalSteps = contentState.totalSteps,
           totalSteps > 0
        {
          SegmentedProgressView(
            currentStep: currentStep,
            totalSteps: totalSteps,
            activeColor: attributes.segmentActiveColor,
            inactiveColor: attributes.segmentInactiveColor
          )
        } else if let startDate = contentState.elapsedTimerStartDateInMilliseconds {
          ElapsedTimerText(
            startTimeMilliseconds: startDate,
            color: attributes.progressViewLabelColor.map { Color(hex: $0) }
          )
          .font(.title2)
          .fontWeight(.semibold)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.top, 4)
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
