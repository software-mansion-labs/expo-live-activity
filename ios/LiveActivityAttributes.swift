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
  var padding: Int?
  var paddingConfig: PaddingConfig?
  var imagePosition: String?
  var imageSize: String?

  enum DynamicIslandTimerType: String, Codable {
    case circular
    case digital
  }
    
    struct PaddingConfig: Codable, Hashable {
       var top: Int?
       var bottom: Int?
       var left: Int?
       var right: Int?
       var vertical: Int?
       var horizontal: Int?
     }
}
