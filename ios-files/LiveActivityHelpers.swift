import SwiftUI
import WidgetKit

extension LiveActivityAttributes.ContentState {
  var hasSegmentedProgress: Bool {
    currentStep != nil && (totalSteps ?? 0) > 0
  }

  func logSegmentedProgressWarningIfNeeded() {
    #if DEBUG
      if hasSegmentedProgress,
         elapsedTimerStartDateInMilliseconds != nil
         || timerEndDateInMilliseconds != nil
         || progress != nil
      {
        DebugLog("⚠️[ExpoLiveActivity] Both segmented and regular progress provided; showing segmented")
      }
    #endif
  }
}

extension LiveActivityAttributes {
  var segmentActiveColor: Color {
    progressSegmentActiveColor.map { Color(hex: $0) } ?? Color.blue
  }

  var segmentInactiveColor: Color {
    progressSegmentInactiveColor.map { Color(hex: $0) } ?? Color.gray.opacity(0.3)
  }

  func resolvedPadding(defaultPadding: Int) -> EdgeInsets {
    let top = CGFloat(
      paddingDetails?.top
        ?? paddingDetails?.vertical
        ?? padding
        ?? defaultPadding
    )
    let bottom = CGFloat(
      paddingDetails?.bottom
        ?? paddingDetails?.vertical
        ?? padding
        ?? defaultPadding
    )
    let leading = CGFloat(
      paddingDetails?.left
        ?? paddingDetails?.horizontal
        ?? padding
        ?? defaultPadding
    )
    let trailing = CGFloat(
      paddingDetails?.right
        ?? paddingDetails?.horizontal
        ?? padding
        ?? defaultPadding
    )
    return EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
  }
}
