import ExpoModulesCore

final class UnsupportedOSException: GenericException<String> {
  override var reason: String {
    "Live Activities require iOS \(param) or later. Current version: \(UIDevice.current.systemVersion)"
  }
}

final class ActivityNotFoundException: GenericException<String> {
  override var reason: String {
    "Activity with ID '\(param)' not found"
  }
}

final class LiveActivitiesNotEnabledException: Exception {
  override var reason: String {
    "Live Activities are currently disabled - enable them in Settings > Face ID & Passcode > Live Activities and Settings > [Your App] > Live Activities"
  }
}

final class UnexpectedErrorException: GenericException<Error> {
  override var reason: String {
    "An unexpected error occurred: \(param.localizedDescription)"
  }
}
