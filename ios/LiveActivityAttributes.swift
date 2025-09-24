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
    var timerEndDateInMilliseconds: Double?
    var progress: Double?
    var imageName: String?
    var dynamicIslandImageName: String?
  }

  var name: String
  var backgroundColor: String?
  var titleColor: String?
  var subtitleColor: String?
  var progressViewTint: String?
  var progressViewLabelColor: String?
  var deepLinkUrl: String?
  var timerType: DynamicIslandTimerType?
  var padding: Padding?
  var imagePosition: String?
  var imageSize: String?

  enum DynamicIslandTimerType: String, Codable {
    case circular
    case digital
  }
}
