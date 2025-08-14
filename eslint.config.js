const { defineConfig } = require('eslint/config')
const expoConfig = require('eslint-config-expo/flat')
const eslintPluginPrettierRecommended = require('eslint-plugin-prettier/recommended')
const simpleImportSort = require('eslint-plugin-simple-import-sort')

module.exports = defineConfig([
  expoConfig,
  eslintPluginPrettierRecommended,
  {
    ignores: ['build/*', 'plugin/build/*'],
  },
  defineConfig([
    {
      files: ['example/webpack.config.js'],
      languageOptions: {
        globals: {
          __dirname: 'readonly',
        },
      },
    },
    {
      basePath: 'example',
      settings: {
        'import/resolver': {
          alias: {
            map: [['expo-live-activity', './src']],
            extensions: ['.ts'],
          },
        },
      },
    },
    {
      plugins: {
        'simple-import-sort': simpleImportSort,
      },
      rules: {
        'simple-import-sort/imports': 'error',
        'simple-import-sort/exports': 'error',
      },
    },
  ]),
])
