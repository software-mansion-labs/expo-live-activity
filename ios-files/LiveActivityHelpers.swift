import SwiftUI
import WidgetKit

#if canImport(ActivityKit)
  import ActivityKit

  extension LiveActivityAttributes {
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

#endif
