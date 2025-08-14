import plist from '@expo/plist'
import { ConfigPlugin, InfoPlist, withInfoPlist } from '@expo/config-plugins'
import { readFileSync, writeFileSync } from 'fs'
import { join as joinPath } from 'path'

const withPlist: ConfigPlugin<{ targetName: string }> = (expoConfig, { targetName }) =>
  withInfoPlist(expoConfig, (plistConfig) => {
    const scheme = typeof expoConfig.scheme === 'string' ? expoConfig.scheme : expoConfig.ios?.bundleIdentifier

    if (scheme) {
      const targetPath = joinPath(plistConfig.modRequest.platformProjectRoot, targetName)
      const filePath = joinPath(targetPath, 'Info.plist')
      const content = plist.parse(readFileSync(filePath, 'utf8')) as InfoPlist

      content.CFBundleURLTypes = [
        {
          CFBundleURLSchemes: [scheme],
        },
      ]

      writeFileSync(filePath, plist.build(content))
    }

    return plistConfig
  })

export default withPlist
