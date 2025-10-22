import ActivityKit
import ExpoModulesCore

public class ExpoLiveActivityModule: Module {
  struct LiveActivityState: Record {
    @Field
    var title: String

    @Field
    var subtitle: String?

    @Field
    var progressBar: ProgressBar?

    struct ProgressBar: Record {
      @Field
      var date: Double?

      @Field
      var progress: Double?
    }

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

    @Field
    var padding: Int?

    @Field
    var paddingDetails: PaddingDetails?

    @Field
    var imagePosition: String?

    @Field
    var imageWidth: Int?

    @Field
    var imageHeight: Int?

    @Field
    var imageWidthPercent: Double?

    @Field
    var imageHeightPercent: Double?

    @Field
    var imageAlign: String?

    @Field
    var contentFit: String?

    struct PaddingDetails: Record {
      @Field var top: Int?
      @Field var bottom: Int?
      @Field var left: Int?
      @Field var right: Int?
      @Field var vertical: Int?
      @Field var horizontal: Int?
    }
  }

  enum DynamicIslandTimerType: String, Enumerable {
    case circular
    case digital
  }

  @available(iOS 16.1, *)
  private func sendPushToken(activity: Activity<LiveActivityAttributes>, activityPushToken: String) {
    sendEvent(
      "onTokenReceived",
      [
        "activityID": activity.id,
        "activityName": activity.attributes.name,
        "activityPushToken": activityPushToken,
      ]
    )
  }

  private func sendPushToStartToken(activityPushToStartToken: String) {
    sendEvent(
      "onPushToStartTokenReceived",
      [
        "activityPushToStartToken": activityPushToStartToken,
      ]
    )
  }

  @available(iOS 16.1, *)
  private func sendStateChange(
    activity: Activity<LiveActivityAttributes>, activityState: ActivityState
  ) {
    sendEvent(
      "onStateChange",
      [
        "activityID": activity.id,
        "activityName": activity.attributes.name,
        "activityState": String(describing: activityState),
      ]
    )
  }

  private func updateImages(
    state: LiveActivityState, newState: inout LiveActivityAttributes.ContentState
  ) async throws {
    if let name = state.imageName {
      newState.imageName = try await resolveImage(from: name)
    }

    if let name = state.dynamicIslandImageName {
      newState.dynamicIslandImageName = try await resolveImage(from: name)
    }
  }

  private func observePushToStartToken() {
    guard #available(iOS 17.2, *), ActivityAuthorizationInfo().areActivitiesEnabled else { return }

    print("Observing push to start token updates...")
    Task {
      for await data in Activity<LiveActivityAttributes>.pushToStartTokenUpdates {
        let token = data.reduce("") { $0 + String(format: "%02x", $1) }
        sendPushToStartToken(activityPushToStartToken: token)
      }
    }
  }

  private func observeLiveActivityUpdates() {
    guard #available(iOS 16.2, *) else { return }

    Task {
      for await activityUpdate in Activity<LiveActivityAttributes>.activityUpdates {
        let activityId = activityUpdate.id
        let activityState = activityUpdate.activityState

        print("Received activity update: \(activityId), \(activityState)")

        guard
          let activity = Activity<LiveActivityAttributes>.activities.first(where: {
            $0.id == activityId
          })
        else { return print("Didn't find activity with ID \(activityId)") }

        if case .active = activityState {
          Task {
            for await state in activity.activityStateUpdates {
              sendStateChange(activity: activity, activityState: state)
            }
          }

          if pushNotificationsEnabled {
            print("Adding push token observer for activity \(activity.id)")
            Task {
              for await pushToken in activity.pushTokenUpdates {
                let pushTokenString = pushToken.reduce("") { $0 + String(format: "%02x", $1) }

                sendPushToken(activity: activity, activityPushToken: pushTokenString)
              }
            }
          }
        }
      }
    }
  }

  private var pushNotificationsEnabled: Bool {
    Bundle.main.object(forInfoDictionaryKey: "ExpoLiveActivity_EnablePushNotifications") as? Bool
      ?? false
  }

  public func definition() -> ModuleDefinition {
    Name("ExpoLiveActivity")

    OnCreate {
      if pushNotificationsEnabled {
        observePushToStartToken()
      }
      observeLiveActivityUpdates()
    }

    Events("onTokenReceived", "onPushToStartTokenReceived", "onStateChange")

    Function("startActivity") {
      (state: LiveActivityState, maybeConfig: LiveActivityConfig?) -> String in
      guard #available(iOS 16.2, *) else { throw UnsupportedOSException("16.2") }

      guard ActivityAuthorizationInfo().areActivitiesEnabled else {
        throw LiveActivitiesNotEnabledException()
      }

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
          timerType: config.timerType == .digital ? .digital : .circular,
          padding: config.padding,
          paddingDetails: config.paddingDetails.map {
            LiveActivityAttributes.PaddingDetails(
              top: $0.top,
              bottom: $0.bottom,
              left: $0.left,
              right: $0.right,
              vertical: $0.vertical,
              horizontal: $0.horizontal
            )
          },
          imagePosition: config.imagePosition,
          imageWidth: config.imageWidth,
          imageHeight: config.imageHeight,
          imageWidthPercent: config.imageWidthPercent,
          imageHeightPercent: config.imageHeightPercent,
          imageAlign: config.imageAlign,
          contentFit: config.contentFit
        )

        let initialState = LiveActivityAttributes.ContentState(
          title: state.title,
          subtitle: state.subtitle,
          timerEndDateInMilliseconds: state.progressBar?.date,
          progress: state.progressBar?.progress
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
      } catch {
        throw UnexpectedErrorException(error)
      }
    }

    Function("stopActivity") { (activityId: String, state: LiveActivityState) in
      guard #available(iOS 16.2, *) else { throw UnsupportedOSException("16.2") }

      guard
        let activity = Activity<LiveActivityAttributes>.activities.first(where: {
          $0.id == activityId
        })
      else { throw ActivityNotFoundException(activityId) }

      Task {
        print("Stopping activity with id: \(activityId)")
        var newState = LiveActivityAttributes.ContentState(
          title: state.title,
          subtitle: state.subtitle,
          timerEndDateInMilliseconds: state.progressBar?.date,
          progress: state.progressBar?.progress
        )
        try await updateImages(state: state, newState: &newState)
        await activity.end(
          ActivityContent(state: newState, staleDate: nil),
          dismissalPolicy: .immediate
        )
      }
    }

    Function("updateActivity") { (activityId: String, state: LiveActivityState) in
      guard #available(iOS 16.2, *) else {
        throw UnsupportedOSException("16.2")
      }

      guard
        let activity = Activity<LiveActivityAttributes>.activities.first(where: {
          $0.id == activityId
        })
      else { throw ActivityNotFoundException(activityId) }

      Task {
        print("Updating activity with id: \(activityId)")
        var newState = LiveActivityAttributes.ContentState(
          title: state.title,
          subtitle: state.subtitle,
          timerEndDateInMilliseconds: state.progressBar?.date,
          progress: state.progressBar?.progress
        )
        try await updateImages(state: state, newState: &newState)
        await activity.update(ActivityContent(state: newState, staleDate: nil))
      }
    }
  }
}
