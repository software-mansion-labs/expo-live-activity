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

@ViewBuilder
func fixedSizeImage(name: String, size: CGFloat) -> some View {
  Image.dynamic(assetNameOrPath: name)
    .resizable()
    .scaledToFit()
    .frame(width: size, height: size)
    .layoutPriority(0)
}

@ViewBuilder
func smallTimerText(
  endDate: Double,
  isSubtitleDisplayed: Bool,
  carPlayView: Bool = false,
  labelColor: String?
) -> some View {
  Text(timerInterval: Date.toTimerInterval(miliseconds: endDate))
    .font(carPlayView
      ? (isSubtitleDisplayed ? .footnote : .title2)
      : (isSubtitleDisplayed ? .footnote : .callout))
    .fontWeight(carPlayView && !isSubtitleDisplayed ? .semibold : .medium)
    .modifier(ConditionalForegroundViewModifier(color: labelColor))
    .padding(.top, isSubtitleDisplayed ? 3 : 0)
}

@ViewBuilder
func styledLinearProgressView<Content: View>(
  tint: Color?,
  labelColor: String?,
  @ViewBuilder content: () -> Content
) -> some View {
  content()
    .progressViewStyle(.linear)
    .tint(tint)
    .frame(height: 8.0)
    .scaleEffect(x: 1, y: 2, anchor: .center)
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .modifier(ConditionalForegroundViewModifier(color: labelColor))
    .padding(.bottom, 6)
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
