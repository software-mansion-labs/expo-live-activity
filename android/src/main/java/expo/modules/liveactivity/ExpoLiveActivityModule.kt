package expo.modules.liveactivity

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import java.net.URL

class ExpoLiveActivityModule : Module() {
  override fun definition() = ModuleDefinition {
    Name("ExpoLiveActivity")

    Function("hello") {
      return@Function "hello"
    }
  }
}
