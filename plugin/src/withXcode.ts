import { ConfigPlugin, withXcodeProject } from '@expo/config-plugins'
import * as path from 'path'

import { getWidgetFiles } from './lib/getWidgetFiles'
import { addBuildPhases } from './xcode/addBuildPhases'
import { addPbxGroup } from './xcode/addPbxGroup'
import { addProductFile } from './xcode/addProductFile'
import { addTargetDependency } from './xcode/addTargetDependency'
import { addToPbxNativeTargetSection } from './xcode/addToPbxNativeTargetSection'
import { addToPbxProjectSection } from './xcode/addToPbxProjectSection'
import { addXCConfigurationList } from './xcode/addXCConfigurationList'

export const withXcode: ConfigPlugin<{
  targetName: string
  bundleIdentifier: string
  deploymentTarget: string
}> = (config, { targetName, bundleIdentifier, deploymentTarget }) => {
  return withXcodeProject(config, (config) => {
    const xcodeProject = config.modResults
    const targetUuid = xcodeProject.generateUuid()
    const groupName = 'Embed Foundation Extensions'
    const { platformProjectRoot } = config.modRequest
    const marketingVersion = config.version

    const targetPath = path.join(platformProjectRoot, targetName)

    const widgetFiles = getWidgetFiles(targetPath)

    const xCConfigurationList = addXCConfigurationList(xcodeProject, {
      targetName,
      currentProjectVersion: config.ios!.buildNumber || '1',
      bundleIdentifier,
      deploymentTarget,
      marketingVersion,
    })

    const productFile = addProductFile(xcodeProject, {
      targetName,
      groupName,
    })

    const target = addToPbxNativeTargetSection(xcodeProject, {
      targetName,
      targetUuid,
      productFile,
      xCConfigurationList,
    })

    addToPbxProjectSection(xcodeProject, target)

    addTargetDependency(xcodeProject, target)

    addBuildPhases(xcodeProject, {
      targetUuid,
      groupName,
      productFile,
      widgetFiles,
    })

    addPbxGroup(xcodeProject, {
      targetName,
      widgetFiles,
    })

    return config
  })
}
