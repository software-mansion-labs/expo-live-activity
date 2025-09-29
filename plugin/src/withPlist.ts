import { ConfigPlugin, withInfoPlist } from '@expo/config-plugins'

const withPlist: ConfigPlugin = (expoConfig) =>
  withInfoPlist(expoConfig, (plistConfig) => {
    const scheme = typeof expoConfig.scheme === 'string' ? expoConfig.scheme : expoConfig.ios?.bundleIdentifier
    if (scheme) plistConfig.modResults.CFBundleURLTypes = [{ CFBundleURLSchemes: [scheme] }]
    return plistConfig
  })

export default withPlist
