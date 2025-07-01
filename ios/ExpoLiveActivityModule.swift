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
        var timeAsText: Bool?
    }

    public func definition() -> ModuleDefinition {
        Name("ExpoLiveActivity")

        Function("startActivity") { (state: LiveActivityState, styles: LiveActivityStyles? ) -> String in
            print("Starting activity")
            if #available(iOS 16.2, *) {
                if ActivityAuthorizationInfo().areActivitiesEnabled {
                    do {
                        let counterState = LiveActivityAttributes(
                            name: "ExpoLiveActivity",
                            backgroundColor: styles?.backgroundColor,
                            titleColor: styles?.titleColor,
                            subtitleColor: styles?.subtitleColor,
                            progressViewTint: styles?.progressViewTint,
                            progressViewLabelColor: styles?.progressViewLabelColor,
                            timeAsText: styles?.timeAsText ?? false
                        )
                        let initialState = LiveActivityAttributes.ContentState(
                            title: state.title,
                            subtitle: state.subtitle,
                            date: state.date != nil ? Date(timeIntervalSince1970: state.date! / 1000) : nil,
                            imageName: state.imageName,
                            dynamicIslandImageName: state.dynamicIslandImageName)
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
                throw ModuleErrors.unsupported
            }
        }

        Function("stopActivity") { (activityId: String, state: LiveActivityState) -> Void in
            if #available(iOS 16.2, *) {
                print("Attempting to stop")
                let endState = LiveActivityAttributes.ContentState(
                    title: state.title,
                    subtitle: state.subtitle,
                    date: state.date != nil ? Date(timeIntervalSince1970: state.date! / 1000) : nil,
                    imageName: state.imageName,
                    dynamicIslandImageName: state.dynamicIslandImageName)
                if let activity = Activity<LiveActivityAttributes>.activities.first(where: {
                    $0.id == activityId
                }) {
                    Task {
                        print("Stopping activity with id: \(activityId)")
                        await activity.end(
                            ActivityContent(state: endState, staleDate: nil),
                            dismissalPolicy: .immediate)
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
                let newState = LiveActivityAttributes.ContentState(
                    title: state.title,
                    subtitle: state.subtitle,
                    date: state.date != nil ? Date(timeIntervalSince1970: state.date! / 1000) : nil,
                    imageName: state.imageName,
                    dynamicIslandImageName: state.dynamicIslandImageName)
                if let activity = Activity<LiveActivityAttributes>.activities.first(where: {
                    $0.id == activityId
                }) {
                    Task {
                        print("Updating activity with id: \(activityId)")
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
