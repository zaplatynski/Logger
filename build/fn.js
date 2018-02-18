const
  path = require('path'),
  fs = require('fs'),
  config = require('./config.js')
;

var functions = {};

/**
 * Returns JSON object of parameters
 * Will validate and exit if parameters are Invalid
 *
 */
functions.getParameters = function () {

  // Parameters
  let params = {
    help: 'Run: node build <version major.minor.patch>',
    // If process.argv.splice(2) is called before it will be null here
    valArr: process.argv.splice(2), // Array of variables passed in via command line
    values: {
      version: ''
    },
    valid: true, // Update if not valid
    errMsg: '' // if not valid, then display this message
  }// params

  if (params.valArr.length < 1) {
    params.errMsg = 'Missing parameters.';
  }
  else {
    // Define all parameters
    params.values.version = params.valArr[0];
  }

  // Test params
  if (!/\d+\.\d+\.\d+/.test(params.values.version)) {
    params.errMsg = 'Version needs to be major.minor.patch'
  }

  // If any parameters are invalid
  if (params.errMsg != '') {
    console.log(`Error: ${params.errMsg}\n${params.help}`);
    process.exit(1);
  }

  // No errors sanitize and return parameters
  var tmpVersion = params.values.version.split('.');
  params.values.version = {
    major: tmpVersion[0],
    minor: tmpVersion[1],
    patch: tmpVersion[2]
  };

  return params.values;
};// getParameters


/**
 * Appends object array to config file
 * @param objArray Array of objects (must all be same. {name, src})
 * @param desc Description (ex TABLES)
 * @param noopReq Boolean: If True will be applied to noOp file
 */
functions.appendObjects= function(objArray, desc, noopReq){

  // TODO #78: Need to build tables for no_op to reference

  functions.fs.appendFile(config.files.install, `\n\nprompt *** ${desc.toUpperCase()} ***\n\n`);
  
  objArray.forEach(function (obj) {
    functions.fs.appendFile(config.files.install, `\nprompt ${obj.name}\n`);
    functions.fs.appendFile(config.files.install, functions.fs.readFile(obj.src));
  }); // tables
};//appendObjects


// File Wrapper Functions
functions.fs = {};

/**
 *
 */
functions.fs.appendFile = function (pFile, pContent) {
  fs.appendFileSync(path.resolve(__dirname, pFile), pContent + '\n');
};// appendFile

/**
 *
 */
functions.fs.readFile = function (pFile) {
  return fs.readFileSync(path.resolve(__dirname, pFile), 'utf8');
};// readFile

/**
 *
 */
functions.fs.writeFile = function (pFile, pContent) {
  fs.writeFileSync(path.resolve(__dirname, pFile), pContent);
};// writeFile


module.exports = functions;