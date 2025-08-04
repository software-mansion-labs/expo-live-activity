import ActivityKit
import ExpoModulesCore

enum ModuleErrors: Error {
  case unsupported
  case liveActivitiesNotEnabled
}

public class ExpoLiveActivityModule: Module {
  struct LiveActivityState: Record {
    @Field
    var title: String

    @Field
    var subtitle: String?

    @Field
    var date: Double?

    @Field
    var imageName: String?

    @Field
    var dynamicIslandImageName: String?
  }

  struct LiveActivityStyles: Record {
    @Field
    var backgroundColor: String?

    @Field
    var titleColor: String?

    @Field
    var subtitleColor: String?

    @Field
    var progressViewTint: String?

    @Field
    var progressViewLabelColor: String?

    @Field
    var timerType: DynamicIslandTimerType?
  }

  enum DynamicIslandTimerType: String, Enumerable {
    case circular
    case digital
  }

  func sendPushToken(activityID: String, activityPushToken: String) {
    sendEvent(
      "onTokenReceived",
      [
        "activityID": activityID,
        "activityPushToken": activityPushToken,
      ]
    )
  }

  func toContentStateDate(date: Double?) -> Date? {
    return date.map { Date(timeIntervalSince1970: $0 / 1000) }
  }

  func updateImages(state: LiveActivityState, newState: inout LiveActivityAttributes.ContentState) async throws {
    if let name = state.imageName {
      print("imageName: \(name)")
      newState.imageName = try await resolveImage(from: name)
    }

    if let name = state.dynamicIslandImageName {
      print("dynamicIslandImageName: \(name)")
      newState.dynamicIslandImageName = try await resolveImage(from: name)
    }
  }

  public func definition() -> ModuleDefinition {
    Name("ExpoLiveActivity")

    Events("onTokenReceived")

    Function("startActivity") { (state: LiveActivityState, styles: LiveActivityStyles?) -> String in
      print("Starting activity")
      if #available(iOS 16.2, *) {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
          do {
            let attributes = LiveActivityAttributes(
              name: "ExpoLiveActivity",
              backgroundColor: styles?.backgroundColor,
              titleColor: styles?.titleColor,
              subtitleColor: styles?.subtitleColor,
              progressViewTint: styles?.progressViewTint,
              progressViewLabelColor: styles?.progressViewLabelColor,
              timerType: styles?.timerType == .digital ? .digital : .circular
            )
            let initialState = LiveActivityAttributes.ContentState(
              title: state.title,
              subtitle: state.subtitle,
              date: toContentStateDate(date: state.date),
            )
            let pushNotificationsEnabled =
              Bundle.main.object(forInfoDictionaryKey: "ExpoLiveActivity_EnablePushNotifications")
            let activity = try Activity.request(
              attributes: attributes,
              content: .init(state: initialState, staleDate: nil),
              pushType: pushNotificationsEnabled == nil ? nil : .token
            )

            Task {
              for await pushToken in activity.pushTokenUpdates {
                let pushTokenString = pushToken.reduce("") { $0 + String(format: "%02x", $1) }

                sendPushToken(activityID: activity.id, activityPushToken: pushTokenString)
              }
            }

            Task {
              var newState = activity.content.state
              try await updateImages(state: state, newState: &newState)
              await activity.update(ActivityContent(state: newState, staleDate: nil))
            }

            return activity.id
          } catch (let error) {
            print("Error with live activity: \(error)")
          }
        }
        throw ModuleErrors.liveActivitiesNotEnabled
      } else {
        throw ModuleErrors.unsupported
      }
    }

    Function("stopActivity") { (activityId: String, state: LiveActivityState) -> Void in
      if #available(iOS 16.2, *) {
        print("Attempting to stop")
        var newState = LiveActivityAttributes.ContentState(
          title: state.title,
          subtitle: state.subtitle,
          date: toContentStateDate(date: state.date),
        )
        if let activity = Activity<LiveActivityAttributes>.activities.first(where: {
          $0.id == activityId
        }) {
          Task {
            print("Stopping activity with id: \(activityId)")
            try await updateImages(state: state, newState: &newState)
            await activity.end(
              ActivityContent(state: newState, staleDate: nil),
              dismissalPolicy: .immediate
            )
          }
        } else {
          print("Didn't find activity with ID \(activityId)")
        }
      } else {
        throw ModuleErrors.unsupported
      }
    }

    Function("updateActivity") { (activityId: String, state: LiveActivityState) -> Void in
      if #available(iOS 16.2, *) {
        print("Attempting to update")
        var newState = LiveActivityAttributes.ContentState(
          title: state.title,
          subtitle: state.subtitle,
          date: toContentStateDate(date: state.date),
        )
        if let activity = Activity<LiveActivityAttributes>.activities.first(where: {
          $0.id == activityId
        }) {
          Task {
            print("Updating activity with id: \(activityId)")
            try await updateImages(state: state, newState: &newState)
            await activity.update(ActivityContent(state: newState, staleDate: nil))
          }
        } else {
          print("Didn't find activity with ID \(activityId)")
        }
      } else {
        throw ModuleErrors.unsupported
      }
    }
  }
}
