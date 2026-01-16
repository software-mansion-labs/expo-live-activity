import SwiftUI
import WidgetKit

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

struct SegmentedProgressView: View {
  let currentStep: Int
  let totalSteps: Int
  let activeColor: Color
  let inactiveColor: Color

  var body: some View {
    let clampedCurrentStep = min(max(currentStep, 0), totalSteps)
    HStack(spacing: 4) {
      ForEach(0 ..< totalSteps, id: \.self) { index in
        RoundedRectangle(cornerRadius: 2)
          .fill(index < clampedCurrentStep ? activeColor : inactiveColor)
          .frame(height: 4)
      }
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

  var body: some View {
    if #available(iOS 18.0, *) {
      LiveActivityView_iOS18(
        contentState: contentState,
        attributes: attributes,
        imageContainerSize: $imageContainerSize,
        smallView: {
          LiveActivitySmallView(
            contentState: contentState,
            attributes: attributes,
            imageContainerSize: $imageContainerSize,
            alignedImage: { imageName, horizontalAlignment, mobile in
              AnyView(alignedImage(imageName: imageName, horizontalAlignment: horizontalAlignment, mobile: mobile))
            }
          )
        },
        mediumView: {
          LiveActivityMediumView(
            contentState: contentState,
            attributes: attributes,
            imageContainerSize: $imageContainerSize,
            alignedImage: { imageName, horizontalAlignment, mobile in
              AnyView(alignedImage(imageName: imageName, horizontalAlignment: horizontalAlignment, mobile: mobile))
            }
          )
        }
      )
    } else {
      // iOS 17: missing activityFamily in environment -> default to medium
      LiveActivityMediumView(
        contentState: contentState,
        attributes: attributes,
        imageContainerSize: $imageContainerSize,
        alignedImage: { imageName, horizontalAlignment, mobile in
          AnyView(alignedImage(imageName: imageName, horizontalAlignment: horizontalAlignment, mobile: mobile))
        }
      )
    }
  }

  private func alignedImage(imageName: String, horizontalAlignment: HorizontalAlignment, mobile: Bool = false) -> some View {
    let defaultHeight: CGFloat = mobile ? 28 : 64
    let defaultWidth: CGFloat = mobile ? 28 : 64
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
