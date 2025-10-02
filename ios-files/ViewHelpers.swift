import SwiftUI

func resizableImage(imageName: String) -> some View {
  Image.dynamic(assetNameOrPath: imageName)
    .resizable()
    .scaledToFit()
}

extension View {
  @ViewBuilder
  func applyImageSize(_ size: Int?) -> some View {
    frame(maxHeight: CGFloat(size ?? 64))
  }
}
