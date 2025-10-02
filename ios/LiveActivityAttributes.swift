import ActivityKit
import Foundation

struct LiveActivityAttributes: ActivityAttributes {
  struct ContentState: Codable, Hashable {
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
  var paddingDetails: PaddingDetails?
  var imagePosition: String?
  var imageSize: Int?
  var imageAlign: String?

  enum DynamicIslandTimerType: String, Codable {
    case circular
    case digital
  }

  struct PaddingDetails: Codable, Hashable {
    var top: Int?
    var bottom: Int?
    var left: Int?
    var right: Int?
    var vertical: Int?
    var horizontal: Int?
  }
}
