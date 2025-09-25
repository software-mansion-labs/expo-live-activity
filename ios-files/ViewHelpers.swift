import SwiftUI

func resizableImage(imageName: String) -> some View {
  Image.dynamic(assetNameOrPath: imageName)
    .resizable()
    .scaledToFit()
}

extension View {
  @ViewBuilder
  func applyImageSize(_ size: String?) -> some View {
    switch size {
    case "fullHeight":
      frame(maxHeight: .infinity)
    default:
      frame(maxHeight: 64)
    }
  }
}
