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
        var subtitle: String

         @Field
         var date: Double
    }
    
    public func definition() -> ModuleDefinition {
        Name("ExpoLiveActivity")

        Function("startActivity") { (state: LiveActivityState) -> String in
            print("Starting activity")
            if #available(iOS 16.2, *) {
                if ActivityAuthorizationInfo().areActivitiesEnabled {
                    do {
                        let counterState = LiveActivityAttributes(name: "Counter")
                        let initialState = LiveActivityAttributes.ContentState(
                            title: state.title, subtitle: state.subtitle,
                            date: Date(timeIntervalSince1970: state.date/1000))
                        let activity = try Activity.request(
                            attributes: counterState,
                            content: .init(state: initialState, staleDate: nil), pushType: nil)
                        return activity.id
                    } catch (let error) {
                        print("Error with live activity: \(error)")
                    }
                }
                throw ModuleErrors.liveActivitiesNotEnabled
            } else {
                // Fallback on earlier versions
                throw ModuleErrors.unsupported
            }
        }
        
        Function("stopActivity") { (activityId: String, state: LiveActivityState) -> Void in
            if #available(iOS 16.2, *) {
                print("Attempting to stop")
                let endState = LiveActivityAttributes.ContentState(
                    title: state.title, subtitle: state.subtitle,
                    date: Date(timeIntervalSince1970: state.date/1000))
                if let activity = Activity<LiveActivityAttributes>.activities.first(where: { $0.id == activityId }) {
                    Task {
                        print("Stopping activity with id: \(activityId)")
                        await activity.end(ActivityContent(state: endState, staleDate: nil), dismissalPolicy: .immediate)
                    }
                } else {
                    print("Didn't find activity with ID \(activityId)")
                }
            } else {
                // Fallback on earlier versions
                throw ModuleErrors.unsupported
            }
        }
    }
}
