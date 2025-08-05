//
//  View+applyWidgetURL.swift
//
//
//  Created by Artur Bilski on 05/08/2025.
//

import SwiftUI

extension View {
  @ViewBuilder
  func applyWidgetURL(from urlString: String?) -> some View {
    applyIfPresent(urlString) { view, string in view.widgetURL(URL(string: string))}
  }
}
