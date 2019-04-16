module.exports = {
  searchDirectory: "./javascripts/app",
  outputFileExtension: "js"
  // useJSModules: true,
  jscodeshiftScripts: [
    'codeshifts/unwrap-amd.js',
    'node_modules/5to6-codemod/transforms/cjs.js',
    'codeshifts/cleanup-import.js',
    'codeshifts/cleanup-export.js',
    'codeshifts/replace-init-class.js'
  ],
  // fixImportsConfig: {
  //   searchPath: './javascripts/app',
  //   absoluteImportPaths: ['./javascripts/app'],
  // },
};
