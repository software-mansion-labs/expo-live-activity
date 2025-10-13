import SwiftUI

func resizableImage(imageName: String) -> some View {
  Image.dynamic(assetNameOrPath: imageName)
    .resizable()
    .scaledToFit()
}

// Overload that accepts explicit height
func resizableImage(imageName: String, height: CGFloat?) -> some View {
  resizableImage(imageName: imageName)
    .frame(height: height)
}

// Compute height for image based on points or percent of a reference height
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

  #if DEBUG
    print("[ExpoLiveActivity] computeImageHeight size=\(String(describing: size)) percent=\(String(describing: percent)) referenceHeight=\(String(describing: referenceHeight)) base=\(base) -> result=\(result)")
  #endif

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

    // Attach a lightweight debug logger without breaking ViewBuilder
    #if DEBUG
      return frame(height: resultingHeight)
        .background(
          Color.clear.onAppear {
            print(
              "[ExpoLiveActivity] applyImageSize size=\(String(describing: size)) percent=\(String(describing: percent)) containerHeight=\(String(describing: containerHeight)) -> resultingHeight=\(resultingHeight)"
            )
          }
        )
    #else
      return frame(height: resultingHeight)
    #endif
  }
}
