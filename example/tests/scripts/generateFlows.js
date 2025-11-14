const fs = require('fs')
const mainPath = './example/tests'
const APP_ID = process.env.MAESTRO_APP_ID || 'com.swmansion.expoliveactivity.example'

const configs = JSON.parse(fs.readFileSync(`${mainPath}/configs.json`, 'utf-8'))

fs.mkdirSync(`${mainPath}/generated`, { recursive: true })
fs.mkdirSync(`${mainPath}/videos`, { recursive: true })
fs.mkdirSync(`${mainPath}/screenshots`, { recursive: true })

for (const test of configs) {
  const { id, title, config } = test
  const configJson = JSON.stringify(config).replace(/'/g, "''")

  const yaml = `
appId: ${APP_ID}
---
- startRecording
- launchApp:
      clearState: true
      permissions:
          all: unset
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
- tapOn: "${
    config.contentFit === 'scale-down'
      ? 'Scale Down'
      : config.contentFit.charAt(0).toUpperCase() + config.contentFit.slice(1)
  }"
- scrollUntilVisible:
    element:
        id: "btn-start-activity"
- tapOn:
    id: "btn-start-activity"
    repeat: 2
    delay: 10000
- stopApp
- swipe:
      start: 20%, 2%
      end: 20%, 80%
      duration: 200
- tapOn:
      point: 50%,50%
      repeat: 2
      delay: 3000
- extendedWaitUntil:
    visible: "Title"
    timeout: 3000
    optional: true
- tapOn:
    text: "Allow"
    optional: true
- takeScreenshot: ${mainPath}/screenshots/${id}
- stopRecording: ${mainPath}/videos/${id}.mp4
`

  fs.writeFileSync(`${mainPath}/generated/${id}.yaml`, yaml.trim())
  console.log(`✅ generated flow for: ${title}`)
}
