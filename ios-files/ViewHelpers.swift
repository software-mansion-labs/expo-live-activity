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
      self.frame(maxHeight: .infinity)
    default:
      self.frame(maxHeight: 64)
    }
  }
}