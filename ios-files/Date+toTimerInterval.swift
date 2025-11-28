import SwiftUI

extension Date {
  static func toTimerInterval(miliseconds: Double) -> ClosedRange<Self> {
    now ... max(now, Date(timeIntervalSince1970: miliseconds / 1000))
  }

  static func toElapsedTimerInterval(miliseconds: Double) -> ClosedRange<Self> {
    Date(timeIntervalSince1970: miliseconds / 1000) ... now
  }
}
