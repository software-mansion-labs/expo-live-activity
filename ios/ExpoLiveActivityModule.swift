import ExpoModulesCore

public class ExpoLiveActivityModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoLiveActivity")

    Function("hello") { () -> String in
      return "Hello world! 👋"
    }
  }
}
