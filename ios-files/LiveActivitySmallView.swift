import SwiftUI
import WidgetKit

#if canImport(ActivityKit)
  import ActivityKit

  struct LiveActivitySmallView: View {
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
      return hasProgress || (hasTimer && !isSubtitleDisplayed && !isTimerShownAsText)
    }

    var body: some View {
      let padding = attributes.resolvedPadding(defaultPadding: 8)

      VStack(alignment: .leading, spacing: 4) {
        VStack(alignment: .leading, spacing: shouldShowProgressBar ? 0 : nil) {
          HStack(alignment: .center, spacing: 8) {
            if hasImage, isLeftImage, !isTimerShownAsText {
              if let imageName = contentState.imageName {
                alignedImage(imageName, .leading, true)
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
                alignedImage(imageName, .trailing, true)
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
      .preferredColorScheme(.light)
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

#endif
