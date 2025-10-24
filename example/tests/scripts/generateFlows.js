// scripts/generateFlows.js
const fs = require('fs')
const mainPath = './example/tests'
const APP_ID = process.env.MAESTRO_APP_ID || 'com.swmansion.expoliveactivity.example'
const configs = JSON.parse(fs.readFileSync(`${mainPath}/configs.json`, 'utf-8'))
fs.mkdirSync(`${mainPath}/generated`, { recursive: true })

function labelForContentFit(fit) {
  if (!fit) return ''
  if (fit === 'scale-down') return 'Scale Down'
  return fit.charAt(0).toUpperCase() + fit.slice(1)
}

function labelForImagePosition(pos) {
  switch (pos) {
    case 'left':
      return 'Left'
    case 'right':
      return 'Right'
    case 'leftStretch':
      return 'Left (stretch)'
    case 'rightStretch':
      return 'Right (stretch)'
    default:
      return ''
  }
}

function labelForImageAlign(a) {
  switch (a) {
    case 'top':
      return 'Top'
    case 'center':
      return 'Center'
    case 'bottom':
      return 'Bottom'
    default:
      return ''
  }
}

for (const test of configs) {
  const { id, title, config } = test

  const cfLabel = labelForContentFit(config.contentFit)
  const ipLabel = labelForImagePosition(config.imagePosition)
  const iaLabel = labelForImageAlign(config.imageAlign)

  // Padding block (single number or detailed)
  let paddingBlock = ''
  if (config.padding !== undefined) {
    if (typeof config.padding === 'number') {
      paddingBlock = `- tapOn:\n    id: "input-padding-single"\n- inputText: '${config.padding}'\n`
    } else if (typeof config.padding === 'object') {
      const keys = ['top', 'bottom', 'left', 'right', 'vertical', 'horizontal']
      let detailLines = `
- scroll
- scrollUntilVisible:
    element:
      id: switch-show-padding-details\n`
      detailLines += '- tapOn:\n    id: switch-show-padding-details\n'
      for (const k of keys) {
        if (config.padding[k] !== undefined) {
          detailLines += `- tapOn:\n    id: "input-padding-${k}"\n- inputText: '${config.padding[k]}'\n`
        }
      }
      paddingBlock = detailLines
    }
  }

  const yaml = `appId: ${APP_ID}
---
- launchApp:
      clearState: true
      permissions:
          all: unset
- tapOn:
    id: "input-title"
- inputText: '${config.titleText ?? ''}'
- tapOn:
    id: "input-subtitle"
- inputText: '${config.subtitleText ?? ''}'
- tapOn:
    id: "input-image-width"
- inputText: '${config.imageSize?.width ?? ''}'
- tapOn:
    id: "input-image-width-label"
- tapOn:
    id: "input-image-height"
- inputText: '${config.imageSize?.height ?? ''}'
- tapOn:
    id: "input-image-height-label"
- tapOn:
    id: "dropdown-content-fit"
${cfLabel ? `- tapOn: "${cfLabel}"` : ''}
${config.imagePosition ? `- tapOn:\n    id: "dropdown-image-position"\n- tapOn: "${ipLabel}"` : ''}
${config.imageAlign ? `- tapOn:\n    id: "dropdown-image-align"\n- tapOn: "${iaLabel}"` : ''}
${paddingBlock}
- scrollUntilVisible:
    element:
        id: "btn-start-activity"
- tapOn:
    id: "btn-start-activity"
    delay: 3000
- stopApp
- swipe:
      start: 20%, 2%
      end: 20%, 80%
      duration: 200
- tapOn:
      point: 50%,50%
- tapOn:
    text: "Allow"
    delay: 500

- takeScreenshot: ${mainPath}/screenshots/${id}`

  fs.writeFileSync(`${mainPath}/generated/${id}.yaml`, yaml.trim())
  console.log(`✅ generated flow for: ${title}`)
}
