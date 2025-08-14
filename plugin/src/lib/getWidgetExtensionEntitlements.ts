import { ExportedConfig, InfoPlist } from '@expo/config-plugins'

interface Options {
  groupIdentifier?: string
}

export function getWidgetExtensionEntitlements(_iosConfig: ExportedConfig['ios'], _options: Options | undefined = {}) {
  const entitlements: InfoPlist = {}

  addApplicationGroupsEntitlement(entitlements)

  return entitlements
}

export function addApplicationGroupsEntitlement(entitlements: InfoPlist, groupIdentifier?: string) {
  // if (groupIdentifier) {
  //   const existingApplicationGroups = (entitlements["com.apple.security.application-groups"] as string[]) ?? [];

  //   entitlements["com.apple.security.application-groups"] = [groupIdentifier, ...existingApplicationGroups];
  // }

  return entitlements
}
