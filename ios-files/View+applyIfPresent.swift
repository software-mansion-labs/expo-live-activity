//
//  View+applyIfPresent.swift
//
//
//  Created by Artur Bilski on 05/08/2025.
//

import SwiftUI

extension View {
  @ViewBuilder
  func applyIfPresent<T>(_ value: T?, transform: (Self, T) -> some View) -> some View {
    if let value {
      transform(self, value)
    } else {
      self
    }
  }
}
