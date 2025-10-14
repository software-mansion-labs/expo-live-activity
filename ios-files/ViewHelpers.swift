import SwiftUI

func resizableImage(imageName: String) -> some View {
  Image.dynamic(assetNameOrPath: imageName)
    .resizable()
    .scaledToFit()
}

func resizableImage(imageName: String, height: CGFloat?, width: CGFloat?) -> some View {
  resizableImage(imageName: imageName)
    .frame(width: width, height: height)
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

private struct ContainerSizeKey: PreferenceKey {
  static var defaultValue: CGSize?
  static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
    value = nextValue() ?? value
  }
}

extension View {
  func captureContainerSize() -> some View {
    background(
      GeometryReader { proxy in
        Color.clear.preference(key: ContainerSizeKey.self, value: proxy.size)
      }
    )
  }

  func onContainerSize(_ perform: @escaping (CGSize?) -> Void) -> some View {
    onPreferenceChange(ContainerSizeKey.self, perform: perform)
  }
}

// legacy helper removed; callers moved to explicit width/height sizing
