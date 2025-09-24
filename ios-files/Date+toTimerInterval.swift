import SwiftUI

extension Date {
  static func toTimerInterval(miliseconds: Double) -> ClosedRange<Self> {
    Self.now...max(Self.now, Date(timeIntervalSince1970: miliseconds / 1000))
  }
}
