import * as fs from 'fs'
import * as path from 'path'

/**
 * Injects CFBundleURLTypes into the widget target's Info.plist if not already present.
 * This allows the widget extension to share the app's URL scheme for deep linking.
 */
export function addUrlSchemeToInfoPlist(targetPath: string, scheme: string): void {
  const infoPlistPath = path.join(targetPath, 'Info.plist')

  if (!fs.existsSync(infoPlistPath)) return

  const plistContent = fs.readFileSync(infoPlistPath, 'utf8')

  if (plistContent.includes('CFBundleURLTypes')) return

  const urlTypes = [
    `\t<key>CFBundleURLTypes</key>`,
    `\t<array>`,
    `\t\t<dict>`,
    `\t\t\t<key>CFBundleURLSchemes</key>`,
    `\t\t\t<array>`,
    `\t\t\t\t<string>${scheme}</string>`,
    `\t\t\t</array>`,
    `\t\t</dict>`,
    `\t</array>`,
  ].join('\n')

  const updatedContent = plistContent.replace(/(<\/dict>\s*<\/plist>)/, `${urlTypes}\n$1`)

  fs.writeFileSync(infoPlistPath, updatedContent, 'utf8')
}
