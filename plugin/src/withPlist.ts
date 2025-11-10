import { ConfigPlugin, withInfoPlist } from '@expo/config-plugins'

const withPlist: ConfigPlugin = (expoConfig) =>
  withInfoPlist(expoConfig, (plistConfig) => {
    const scheme = typeof expoConfig.scheme === 'string' ? expoConfig.scheme : expoConfig.ios?.bundleIdentifier

    if (scheme) {
      const existingURLTypes = plistConfig.modResults.CFBundleURLTypes || []
      const schemeExists = existingURLTypes.some((urlType: any) => urlType.CFBundleURLSchemes?.includes(scheme))

      if (!schemeExists) {
        plistConfig.modResults.CFBundleURLTypes = [...existingURLTypes, { CFBundleURLSchemes: [scheme] }]
      }
    }

    return plistConfig
  })

export default withPlist
