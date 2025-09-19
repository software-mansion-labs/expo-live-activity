import ExpoModulesCore

internal final class UnsupportedOSException: GenericException<String> {
  override var reason: String {
    "Live Activities require iOS \(param) or later. Current version: \(UIDevice.current.systemVersion)"
  }
}

internal final class ActivityNotFoundException: GenericException<String> {
  override var reason: String {
    "Activity with ID '\(param)' not found"
  }
}

internal final class LiveActivitiesNotEnabledException: Exception {
  override var reason: String {
    "Live Activities are currently disabled - enable them in Settings > Face ID & Passcode > Live Activities and Settings > [Your App] > Live Activities"
  }
}

internal final class UnexpectedErrorException: GenericException<Error> {
  override var reason: String {
    "An unexpected error occurred: \(param.localizedDescription)"
  }
}
