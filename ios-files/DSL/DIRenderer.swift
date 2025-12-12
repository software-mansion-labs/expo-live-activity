import SwiftUI
import WidgetKit

/// Renders Dynamic Island DSL elements into SwiftUI views
@available(iOS 16.1, *)
public struct DIRenderer {
  public let state: LiveActivityAttributes.ContentState
  public let attributes: LiveActivityAttributes

  public init(state: LiveActivityAttributes.ContentState, attributes: LiveActivityAttributes) {
    self.state = state
    self.attributes = attributes
  }

  // MARK: - Main Render Function

  @ViewBuilder
  public func render(_ element: DIElement?) -> some View {
    if let element = element {
      switch element {
      case .text(let e):
        renderText(e)
      case .sfSymbol(let e):
        renderSFSymbol(e)
      case .image(let e):
        renderImage(e)
      case .progress(let e):
        renderProgress(e)
      case .gauge(let e):
        renderGauge(e)
      case .timer(let e):
        renderTimer(e)
      case .button(let e):
        renderButton(e)
      case .hstack(let e):
        renderHStack(e)
      case .vstack(let e):
        renderVStack(e)
      case .zstack(let e):
        renderZStack(e)
      case .spacer(let e):
        renderSpacer(e)
      }
    }
  }

  // MARK: - Text Rendering

  @ViewBuilder
  private func renderText(_ element: DIText) -> some View {
    let resolvedValue = resolveStringBinding(element.value)

    Text(resolvedValue)
      .font(element.font?.swiftUIFont ?? .body)
      .fontWeight(element.weight?.swiftUIWeight)
      .foregroundColor(element.color.flatMap { Color(hex: $0) })
      .minimumScaleFactor(element.minimumScaleFactor ?? 1.0)
  }

  // MARK: - SF Symbol Rendering

  @ViewBuilder
  private func renderSFSymbol(_ element: DISFSymbol) -> some View {
    let image = Image(systemName: element.name)
      .symbolRenderingMode(element.renderingMode?.swiftUIMode ?? .monochrome)

    let sizedImage = image
      .font(.system(
        size: element.size ?? 17,
        weight: element.weight?.swiftUIWeight ?? .regular
      ))

    // Apply colors based on rendering mode
    if element.renderingMode == .palette {
      sizedImage
        .foregroundStyle(
          element.color.flatMap { Color(hex: $0) } ?? .primary,
          element.secondaryColor.flatMap { Color(hex: $0) } ?? .secondary,
          element.tertiaryColor.flatMap { Color(hex: $0) } ?? .tertiary
        )
    } else {
      sizedImage
        .foregroundColor(element.color.flatMap { Color(hex: $0) })
    }
  }

  // MARK: - Image Rendering

  @ViewBuilder
  private func renderImage(_ element: DIImage) -> some View {
    let resolvedSource = resolveStringBinding(element.source)

    Image.dynamic(assetNameOrPath: resolvedSource)
      .resizable()
      .aspectRatio(contentMode: element.contentMode == .fill ? .fill : .fit)
      .frame(
        width: element.width.map { CGFloat($0) },
        height: element.height.map { CGFloat($0) }
      )
      .applyIfPresent(element.tint.flatMap { Color(hex: $0) }) { view, color in
        view.foregroundColor(color)
      }
  }

  // MARK: - Progress Rendering

  @ViewBuilder
  private func renderProgress(_ element: DIProgress) -> some View {
    let progressValue = resolveDoubleBinding(element.value) ?? 0.0

    if element.style == .circular {
      ProgressView(value: progressValue)
        .progressViewStyle(.circular)
        .tint(element.tint.flatMap { Color(hex: $0) })
    } else {
      ProgressView(value: progressValue)
        .progressViewStyle(.linear)
        .tint(element.tint.flatMap { Color(hex: $0) })
    }
  }

  // MARK: - Gauge Rendering

  @ViewBuilder
  private func renderGauge(_ element: DIGauge) -> some View {
    let gaugeValue = resolveDoubleBinding(element.value) ?? 0.0
    let minValue = element.min ?? 0.0
    let maxValue = element.max ?? 1.0

    switch element.style {
    case .circular, .none:
      Gauge(value: gaugeValue, in: minValue...maxValue) {
        if let label = element.label {
          Text(label)
        }
      }
      .gaugeStyle(.accessoryCircular)
      .tint(element.tint.flatMap { Color(hex: $0) })

    case .linear:
      Gauge(value: gaugeValue, in: minValue...maxValue) {
        if let label = element.label {
          Text(label)
        }
      }
      .gaugeStyle(.accessoryLinear)
      .tint(element.tint.flatMap { Color(hex: $0) })

    case .capacityCircular:
      Gauge(value: gaugeValue, in: minValue...maxValue) {
        if let label = element.label {
          Text(label)
        }
      }
      .gaugeStyle(.accessoryCircularCapacity)
      .tint(element.tint.flatMap { Color(hex: $0) })
    }
  }

  // MARK: - Timer Rendering

  @ViewBuilder
  private func renderTimer(_ element: DITimer) -> some View {
    let endDateMs = resolveDoubleBinding(element.endDate) ?? 0.0
    let timerInterval = Date.toTimerInterval(miliseconds: endDateMs)
    let countsDown = element.countsDown ?? true

    switch element.style {
    case .compact, .none:
      Text(timerInterval: timerInterval, countsDown: countsDown)
        .font(.system(size: 15))
        .fontWeight(.semibold)
        .foregroundColor(element.tint.flatMap { Color(hex: $0) })

    case .offset:
      Text(timerInterval: timerInterval, countsDown: countsDown)
        .font(.caption)
        .foregroundColor(element.tint.flatMap { Color(hex: $0) })

    case .relative:
      Text(Date(timeIntervalSince1970: endDateMs / 1000), style: .relative)
        .font(.caption)
        .foregroundColor(element.tint.flatMap { Color(hex: $0) })

    case .timer:
      ProgressView(
        timerInterval: timerInterval,
        countsDown: countsDown,
        label: { EmptyView() },
        currentValueLabel: { EmptyView() }
      )
      .progressViewStyle(.circular)
      .tint(element.tint.flatMap { Color(hex: $0) })
    }
  }

  // MARK: - Button Rendering

  @ViewBuilder
  private func renderButton(_ element: DIButton) -> some View {
    // Buttons require iOS 17+ for Live Activity interactivity
    if #available(iOS 17.0, *) {
      Button(intent: DIButtonIntent(buttonId: element.id)) {
        renderButtonLabel(element.label)
      }
      .buttonStyle(mapButtonStyle(element.style))
      .tint(element.tint.flatMap { Color(hex: $0) })
    }
    // On iOS 16, buttons simply don't render (graceful degradation)
  }

  @ViewBuilder
  private func renderButtonLabel(_ label: DIButtonLabel) -> some View {
    switch label {
    case .text(let text):
      Text(text)
    case .symbol(let symbol):
      renderSFSymbol(symbol)
    }
  }

  private func mapButtonStyle(_ style: DIButtonStyle?) -> some PrimitiveButtonStyle {
    switch style {
    case .bordered:
      return .bordered
    case .borderedProminent:
      return .borderedProminent
    case .plain, .none:
      return .plain
    }
  }

  // MARK: - Stack Rendering

  @ViewBuilder
  private func renderHStack(_ element: DIHStack) -> some View {
    HStack(
      alignment: element.alignment?.swiftUIAlignment ?? .center,
      spacing: element.spacing.map { CGFloat($0) }
    ) {
      ForEach(Array(element.children.enumerated()), id: \.offset) { _, child in
        render(child)
      }
    }
  }

  @ViewBuilder
  private func renderVStack(_ element: DIVStack) -> some View {
    VStack(
      alignment: element.alignment?.swiftUIAlignment ?? .center,
      spacing: element.spacing.map { CGFloat($0) }
    ) {
      ForEach(Array(element.children.enumerated()), id: \.offset) { _, child in
        render(child)
      }
    }
  }

  @ViewBuilder
  private func renderZStack(_ element: DIZStack) -> some View {
    ZStack(alignment: element.alignment?.swiftUIAlignment ?? .center) {
      ForEach(Array(element.children.enumerated()), id: \.offset) { _, child in
        render(child)
      }
    }
  }

  // MARK: - Spacer Rendering

  @ViewBuilder
  private func renderSpacer(_ element: DISpacer) -> some View {
    if let minLength = element.minLength {
      Spacer(minLength: CGFloat(minLength))
    } else {
      Spacer()
    }
  }

  // MARK: - Binding Resolution

  /// Resolves a binding string (e.g., "$title") to its actual value
  private func resolveStringBinding(_ value: String) -> String {
    guard value.hasPrefix("$") else { return value }

    let fieldName = String(value.dropFirst())

    // Check built-in fields first
    switch fieldName {
    case "title":
      return state.title
    case "subtitle":
      return state.subtitle ?? ""
    case "progress":
      return String(format: "%.0f%%", (state.progress ?? 0) * 100)
    case "imageName":
      return state.imageName ?? ""
    case "dynamicIslandImageName":
      return state.dynamicIslandImageName ?? ""
    default:
      // Check custom fields
      if let customValue = state.customFields?[fieldName] {
        return customValue.stringValue
      }
      return value // Return original if not found
    }
  }

  /// Resolves a binding string to a Double value
  private func resolveDoubleBinding(_ value: String) -> Double? {
    guard value.hasPrefix("$") else {
      return Double(value)
    }

    let fieldName = String(value.dropFirst())

    // Check built-in fields first
    switch fieldName {
    case "progress":
      return state.progress
    case "timerEndDate", "timerEndDateInMilliseconds":
      return state.timerEndDateInMilliseconds
    default:
      // Check custom fields
      if let customValue = state.customFields?[fieldName] {
        return customValue.doubleValue
      }
      return nil
    }
  }
}

// MARK: - Button Intent (iOS 17+)

@available(iOS 17.0, *)
import AppIntents

@available(iOS 17.0, *)
public struct DIButtonIntent: AppIntent {
  public static var title: LocalizedStringResource = "Dynamic Island Button"
  public static var description = IntentDescription("Handles button presses in Dynamic Island")

  @Parameter(title: "Button ID")
  public var buttonId: String

  public init() {
    self.buttonId = ""
  }

  public init(buttonId: String) {
    self.buttonId = buttonId
  }

  public func perform() async throws -> some IntentResult {
    // Post notification that can be observed by the main app
    NotificationCenter.default.post(
      name: Notification.Name("DIButtonPressed"),
      object: nil,
      userInfo: ["buttonId": buttonId]
    )
    return .result()
  }
}
