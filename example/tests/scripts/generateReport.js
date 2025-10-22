const fs = require('fs')
const path = require('path')
const { PDFDocument, StandardFonts } = require('pdf-lib')

async function generateReport() {
  const configsPath = path.resolve('tests/configs.json')
  const screenshotsDir = path.resolve('tests/screenshots')
  const reportsDir = path.resolve('reports')

  if (!fs.existsSync(configsPath)) {
    console.error('❌ tests/configs.json not found!')
    process.exit(1)
  }

  if (!fs.existsSync(screenshotsDir)) {
    console.error('❌ tests/screenshots folder not found!')
    process.exit(1)
  }

  fs.mkdirSync(reportsDir, { recursive: true })

  const configs = JSON.parse(fs.readFileSync(configsPath, 'utf-8'))
  const pdfDoc = await PDFDocument.create()
  const font = await pdfDoc.embedFont(StandardFonts.Helvetica)
  let index = 1
  for (const test of configs) {
    const fileName = `${test.id}.png`
    const filePath = path.join(screenshotsDir, fileName)

    if (!fs.existsSync(filePath)) {
      console.warn(`⚠️ Missing screenshot for test: ${test.title}`)
      continue
    }

    const imageBytes = fs.readFileSync(filePath)
    const image = await pdfDoc.embedPng(imageBytes)
    const page = pdfDoc.addPage([800, 1000])
    const { width, height } = page.getSize()

    // Draw title
    page.drawText(`Test number: ${index}\nTest id: ${test.id}\nTest title: ${test.title}`, {
      x: 50,
      y: height - 50,
      size: 18,
      font,
    })

    // Fit image to page
    const maxWidth = width - 100
    const maxHeight = height - 150
    let imgWidth = image.width
    let imgHeight = image.height
    const scale = Math.min(maxWidth / imgWidth, maxHeight / imgHeight)
    imgWidth *= scale
    imgHeight *= scale

    page.drawImage(image, {
      x: (width - imgWidth) / 2,
      y: 30,
      width: imgWidth,
      height: imgHeight,
    })
    ++index
  }

  const pdfBytes = await pdfDoc.save()
  const outputPath = path.join(reportsDir, 'live-activity-report.pdf')
  fs.writeFileSync(outputPath, pdfBytes)

  console.log(`📄 PDF report generated: ${outputPath}`)
}

generateReport().catch((err) => {
  console.error('❌ Failed to generate PDF:', err)
  process.exit(1)
})
