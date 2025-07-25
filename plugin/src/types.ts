import { ConfigPlugin } from "@expo/config-plugins";

interface ConfigPluginProps {
  enablePushNotificationsEntitlement?: boolean;
}

export type LiveActivityConfigPlugin = ConfigPlugin<ConfigPluginProps>;
