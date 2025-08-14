import ActivityKit
import ExpoModulesCore

enum LiveActivityErrors: Error {
    case unsupportedOS
    case liveActivitiesNotEnabled
    case unexpetedError(Error)
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

  struct LiveActivityConfig: Record {
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
    var deepLinkUrl: String?

    @Field
    var timerType: DynamicIslandTimerType?
  }

  enum DynamicIslandTimerType: String, Enumerable {
    case circular
    case digital
  }

  func sendPushToken(activityID: String, activityName: String, activityPushToken: String) {
    sendEvent(
      "onTokenReceived",
      [
        "activityID": activityID,
        "activityName": activityName,
        "activityPushToken": activityPushToken
      ]
    )
  }
    
  func sendPushToStartToken(activityPushToStartToken: String) {
    sendEvent(
      "onPushToStartTokenReceived",
      [
        "activityPushToStartToken": activityPushToStartToken
      ]
    )
  }

  func updateImages(state: LiveActivityState, newState: inout LiveActivityAttributes.ContentState) async throws {
    if let name = state.imageName {
      newState.imageName = try await resolveImage(from: name)
    }

    if let name = state.dynamicIslandImageName {
      newState.dynamicIslandImageName = try await resolveImage(from: name)
    }
  }
    
  func observePushToStartToken() {
    if #available(iOS 17.2, *), ActivityAuthorizationInfo().areActivitiesEnabled {
      print("Observing push to start token updates...")
      Task {
        for await data in Activity<LiveActivityAttributes>.pushToStartTokenUpdates {
          let token = data.reduce("") { $0 + String(format: "%02x", $1) }
          sendPushToStartToken(activityPushToStartToken: token)
        }
      }
    }
  }

  func observeLiveActivityState() {
    if #available(iOS 16.2, *) {
      Task {
        for await activityUpdate in Activity<LiveActivityAttributes>.activityUpdates {
          switch activityUpdate.activityState {
          case .active:
            print("Received activity state update: \(activityUpdate.id), \(activityUpdate.activityState)")
            let activityId = activityUpdate.id

            if let activity = Activity<LiveActivityAttributes>.activities.first(where: {
              $0.id == activityId
            }) {
              if pushNotificationsEnabled {
                print("Adding push token observer for activity \(activityId)")
                Task {
                  for await pushToken in activity.pushTokenUpdates {
                    let pushTokenString = pushToken.reduce("") { $0 + String(format: "%02x", $1) }

                    sendPushToken(activityID: activity.id, activityName: activity.attributes.name, activityPushToken: pushTokenString)
                  }
                }
              }
            } else {
              print("Didn't find activity with ID \(activityId)")
            }
          default:
            print("Received activity state update: \(activityUpdate.id), \(activityUpdate.activityState)")
          }
        }
      }
    }
  }

  var pushNotificationsEnabled: Bool {
    Bundle.main.object(forInfoDictionaryKey: "ExpoLiveActivity_EnablePushNotifications") as? Bool ?? false
  }

  public func definition() -> ModuleDefinition {
    Name("ExpoLiveActivity")

    OnCreate {
      if pushNotificationsEnabled {
        observePushToStartToken()
      }
      observeLiveActivityState()
    }

    Events("onTokenReceived", "onPushToStartTokenReceived")

    Function("startActivity") { (state: LiveActivityState, maybeConfig: LiveActivityConfig?) -> String in
      print("Starting activity")
      if #available(iOS 16.2, *) {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
          do {
            let config = maybeConfig ?? LiveActivityConfig()
            let attributes = LiveActivityAttributes(
              name: "ExpoLiveActivity",
              backgroundColor: config.backgroundColor,
              titleColor: config.titleColor,
              subtitleColor: config.subtitleColor,
              progressViewTint: config.progressViewTint,
              progressViewLabelColor: config.progressViewLabelColor,
              deepLinkUrl: config.deepLinkUrl,
              timerType: config.timerType == .digital ? .digital : .circular
            )
            let initialState = LiveActivityAttributes.ContentState(
              title: state.title,
              subtitle: state.subtitle,
              timerEndDateInMilliseconds: state.date
            )

            let activity = try Activity.request(
              attributes: attributes,
              content: .init(state: initialState, staleDate: nil),
              pushType: pushNotificationsEnabled ? .token : nil
            )

            Task {
              var newState = activity.content.state
              try await updateImages(state: state, newState: &newState)
              await activity.update(ActivityContent(state: newState, staleDate: nil))
            }

            return activity.id
          } catch let error {
            print("Error with live activity: \(error)")
            throw LiveActivityErrors.unexpetedError(error)
          }
        }
        throw LiveActivityErrors.liveActivitiesNotEnabled
      } else {
        throw LiveActivityErrors.unsupportedOS
      }
    }

    Function("stopActivity") { (activityId: String, state: LiveActivityState) in
      if #available(iOS 16.2, *) {
        print("Attempting to stop")
        var newState = LiveActivityAttributes.ContentState(
          title: state.title,
          subtitle: state.subtitle,
          timerEndDateInMilliseconds: state.date
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
        throw LiveActivityErrors.unsupportedOS
      }
    }

    Function("updateActivity") { (activityId: String, state: LiveActivityState) in
      if #available(iOS 16.2, *) {
        print("Attempting to update")
        var newState = LiveActivityAttributes.ContentState(
          title: state.title,
          subtitle: state.subtitle,
          timerEndDateInMilliseconds: state.date
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
        throw LiveActivityErrors.unsupportedOS
      }
    }
  }
}
