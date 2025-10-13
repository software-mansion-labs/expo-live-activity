import SwiftUI

func resizableImage(imageName: String) -> some View {
  Image.dynamic(assetNameOrPath: imageName)
    .resizable()
    .scaledToFit()
}

func resizableImage(imageName: String, height: CGFloat?) -> some View {
  resizableImage(imageName: imageName)
    .frame(height: height)
}

func computeImageHeight(size: Int?, percent: Double?, referenceHeight: CGFloat?, defaultHeight: CGFloat = 64) -> CGFloat {
  let base: CGFloat
  if let referenceHeight, referenceHeight > 0 {
    base = referenceHeight
  } else {
    base = defaultHeight
  }

  let result: CGFloat
  if let percent = percent {
    let clampedPercent = min(max(percent, 0), 100)
    let ratio = clampedPercent / 100.0
    result = base * ratio
  } else if let size = size {
    result = CGFloat(size)
  } else {
    result = defaultHeight
  }

  return result
}

private struct ContainerHeightKey: PreferenceKey {
  static var defaultValue: CGFloat?
  static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
    value = nextValue() ?? value
  }
}

extension View {
  func captureContainerHeight() -> some View {
    background(
      GeometryReader { proxy in
        Color.clear.preference(key: ContainerHeightKey.self, value: proxy.size.height)
      }
    )
  }

  func onContainerHeight(_ perform: @escaping (CGFloat?) -> Void) -> some View {
    onPreferenceChange(ContainerHeightKey.self, perform: perform)
  }
}

extension View {
  func applyImageSize(_ size: Int?, percent: Double?, containerHeight: CGFloat? = nil) -> some View {
    let defaultHeight: CGFloat = 64

    let resultingHeight: CGFloat = {
      if let percent = percent {
        let clampedPercent = min(max(percent, 0), 100)
        let ratio = clampedPercent / 100.0
        if let h = containerHeight, h > 0 {
          return h * ratio
        } else {
          return defaultHeight * ratio
        }
      } else {
        return CGFloat(size ?? Int(defaultHeight))
      }
    }()

    return frame(height: resultingHeight)
  }
}
