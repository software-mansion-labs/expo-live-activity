import * as fs from "fs";
import * as path from "path";

export type WidgetFiles = {
  swiftFiles: string[];
  entitlementFiles: string[];
  plistFiles: string[];
  assetDirectories: string[];
  intentFiles: string[];
  otherFiles: string[];
};

export function getWidgetFiles(
  // widgetsPath: string, // to zmieniamy, bo u nas to będzie "config.modRequest.projectRoot/[tu może coś jeszcze być]/node_modules/nasz-moduł/iosViews"
  targetPath: string,
  moduleFileName: string,
  attributesFileName: string
) {
  const widgetsPath = "../ios-files"
  const imageAssetsPath = "./assets/live_activity" 
  const widgetFiles: WidgetFiles = {
    swiftFiles: [],
    entitlementFiles: [],
    plistFiles: [],
    assetDirectories: [],
    intentFiles: [],
    otherFiles: [],
  };
  console.log(`Getting widget files`)
  if (!fs.existsSync(targetPath)) {
    console.log(`Making directory at: ${targetPath}`)
    fs.mkdirSync(targetPath, { recursive: true });
  }

  if (fs.lstatSync(widgetsPath).isDirectory()) {
    const files = fs.readdirSync(widgetsPath);
    console.log(`Files: ${files}`)

    files.forEach((file) => {
      const fileExtension = file.split(".").pop();

      if (fileExtension === "swift") {
        if (file !== moduleFileName) {
          widgetFiles.swiftFiles.push(file);
        }
      } else if (fileExtension === "entitlements") {
        widgetFiles.entitlementFiles.push(file);
      } else if (fileExtension === "plist") {
        widgetFiles.plistFiles.push(file);
      } else if (fileExtension === "xcassets") {
        widgetFiles.assetDirectories.push(file);
      } else if (fileExtension === "intentdefinition") {
        widgetFiles.intentFiles.push(file);
      } else {
        widgetFiles.otherFiles.push(file);
      }
    });

  }

  // Copy files
  [
    ...widgetFiles.swiftFiles,
    ...widgetFiles.entitlementFiles,
    ...widgetFiles.plistFiles,
    ...widgetFiles.intentFiles,
    ...widgetFiles.otherFiles,
  ].forEach((file) => {
    const source = path.join(widgetsPath, file);
    copyFileSync(source, targetPath);
  });

  // Copy assets directory
  const imagesXcassetsSource = path.join(widgetsPath, "Assets.xcassets");
  copyFolderRecursiveSync(imagesXcassetsSource, targetPath);

  // Move images to assets directory
  console.log(`Images Path: ${imageAssetsPath}`)
  if (fs.lstatSync(imageAssetsPath).isDirectory()) {
    const imagesXcassetsTarget = path.join(targetPath, "Assets.xcassets");
    console.log(`Assets Target: ${imagesXcassetsTarget}`)

    const files = fs.readdirSync(imageAssetsPath);
    console.log(`Images: ${files}`)
    files.forEach((file) => {
      if (path.extname(file).match(/\.(png|jpg|jpeg)$/)) {
        const source = path.join(imageAssetsPath, file);
        console.log(`Source: ${source}`)
        const imageSetDir = path.join(imagesXcassetsTarget, `${path.basename(file, path.extname(file))}.imageset`);

        console.log(`imageSetDir: ${source}`)
        // Create the .imageset directory if it doesn't exist
        if (!fs.existsSync(imageSetDir)) {
          fs.mkdirSync(imageSetDir, { recursive: true });
        }
        
        // Copy image file to the .imageset directory
        const destPath = path.join(imageSetDir, file);
        fs.copyFileSync(source, destPath);
        
        // Create Contents.json file
        const contentsJson = {
          images: [
            {
              filename : file,
              idiom : "universal"
            }
          ],
          info: {
            author : "xcode",
            version : 1
          }
        };
        
        fs.writeFileSync(
          path.join(imageSetDir, 'Contents.json'),
          JSON.stringify(contentsJson, null, 2) // beautify the JSON output
        );

        console.log(`Processed ${file} into ${imageSetDir}`);
      }
    })
  }

  return widgetFiles;
}

export function copyFileSync(source: string, target: string) {
  let targetFile = target;

  if (fs.existsSync(target) && fs.lstatSync(target).isDirectory()) {
    targetFile = path.join(target, path.basename(source));
  }

  fs.writeFileSync(targetFile, fs.readFileSync(source));
}

function copyFolderRecursiveSync(source: string, target: string) {
  const targetPath = path.join(target, path.basename(source));
  if (!fs.existsSync(targetPath)) {
    fs.mkdirSync(targetPath, { recursive: true });
  }

  if (fs.lstatSync(source).isDirectory()) {
    const files = fs.readdirSync(source);
    files.forEach((file) => {
      const currentPath = path.join(source, file);
      if (fs.lstatSync(currentPath).isDirectory()) {
        copyFolderRecursiveSync(currentPath, targetPath);
      } else {
        copyFileSync(currentPath, targetPath);
      }
    });
  }
}
