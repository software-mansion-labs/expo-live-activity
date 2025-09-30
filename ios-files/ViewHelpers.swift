import SwiftUI

@ViewBuilder
func resizableImage(imageName: String, stretch: Bool = false) -> some View {
  Image.dynamic(assetNameOrPath: imageName)
  .resizable()
  .scaledToFit()
}

extension View {
  @ViewBuilder
  func applyImageSize(_ size: Int?) -> some View {
    if let size {
      frame(maxHeight: CGFloat(size))
    } else {
      frame(maxHeight: 64)
    }
  }
}
