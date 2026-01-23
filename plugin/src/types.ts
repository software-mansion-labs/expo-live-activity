import { ConfigPlugin } from '@expo/config-plugins'

interface ConfigPluginProps {
  enablePushNotifications?: boolean
  silentOnUnsupportedOS?: boolean
}

export type LiveActivityConfigPlugin = ConfigPlugin<ConfigPluginProps | undefined>
