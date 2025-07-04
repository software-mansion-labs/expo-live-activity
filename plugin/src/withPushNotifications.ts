import { ConfigPlugin, withEntitlementsPlist } from "@expo/config-plugins";

export const withPushNotifications: ConfigPlugin = (config) => {
  return withEntitlementsPlist(config, (mod) => {
    mod.modResults["aps-environment"] = "development";
    return mod;
  });
};
