import SwiftUI

func resizableImage(imageName: String) -> some View {
  Image.dynamic(assetNameOrPath: imageName)
    .resizable()
    .scaledToFit()
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
  @ViewBuilder
  func applyImageSize(_ size: Int?, percent: Double?, containerHeight: CGFloat? = nil) -> some View {
    let defaultHeight: CGFloat = 64
    if let percent = percent {
      let clamped = min(max(percent, 0), 100) / 100.0
      if let h = containerHeight, h > 0 {
        frame(height: h * clamped)
      } else {
        frame(height: defaultHeight * clamped)
      }
    } else {
      frame(height: CGFloat(size ?? Int(defaultHeight)))
    }
  }
}
