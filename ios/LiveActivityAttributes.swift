//
//  LiveActivityAttributes.swift
//  ExpoLiveActivity
//
//  Created by Anna Olak on 03/06/2025.
//

import ActivityKit
import Foundation

struct LiveActivityAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var title: String
    var subtitle: String?
    var date: Date?
    var imageName: String?
    var dynamicIslandImageName: String?
  }

  var name: String
  var backgroundColor: String?
  var titleColor: String?
  var subtitleColor: String?
  var progressViewTint: String?
  var progressViewLabelColor: String?
  var timerType: DynamicIslandTimerType

  enum DynamicIslandTimerType: String, Codable {
    case circular
    case digital
  }
}
