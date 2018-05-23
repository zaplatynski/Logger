const fn = require('./fn.js');
const config = require('./config.js');
const path = require('path');
const fs = require('fs');
const exec = require('child_process').exec;

// Parameters
let params = fn.getParameters();
console.log(`Building logger ${params.version.string}`);


// TODO mdsouza: no-op


// for (file in config.files) {
//   fn.writeFile(config.files[file], '');
// }

// Clear Install directory
// let files = fs.readdirSync(path.resolve(__dirname, path.dirname(config.files.install)));

// files.forEach(function(myFile){
//   // As part of new install restructure (#194) be safe to explicitly list files to delete
//   if (myFile === 'logger_install.sql') { 
//     fs.unlinkSync(path.resolve(__dirname, path.dirname(config.files.install), myFile));
//   }
// });


fn.fs.writeFile(config.files.install, '');
fn.fs.writeFile(config.files.installNoop, '');

fn.fs.appendFile(config.files.installNoop, `
-- This file installs a NO-OP version of the logger package that has all of the same procedures and functions
-- but does not actually write to any tables. Additionally, it has no other object dependencies
-- You can review the documentation at https://github.com/OraOpenSource/Logger for more information
alter session set plsql_ccflags='logger_no_op_install:true'
`);

// Pre Install
fn.appendObjects(config.objects.preInstall, 'prereqs', true);

// sequences
fn.appendObjects(config.objects.sequences, 'sequences', false);
// tables
fn.appendObjects(config.objects.tables, 'tables', true);
// jobs
fn.appendObjects(config.objects.jobs, 'jobs', false);
// views
fn.appendObjects(config.objects.views, 'views', true);
// packages
fn.appendObjects(config.objects.packages, 'packages', false);

fn.fs.appendFile(config.files.installNoop, `\n%%%LOGGER_PACAKGE_NOOP%5%\n`);

// TODO noop stuff here
/*
TODO: in config.js store the temp file name
TODO: in generate_noop.sql have a parameter for output file
TODO: merge that file in and 
TODO: OR *** We could just look at taking in the pipped outout and wouldn't need the file
childProcess = execSync(`${sqlclConnectionString} @${config.files.generateNoop}`, { encoding: 'utf8' });
*/

// Recompile logger_prefs trigger as it has dependencies on logger.pks
// TODO mdsouza: go to noop as well
fn.fs.appendFile(config.files.install, `\nprompt Recompile biu_logger_prefs after logger.pkb \n`);
fn.fs.appendFile(config.files.install, `alter trigger biu_logger_prefs compile;\n`);

// contexts
fn.appendObjects(config.objects.contexts, 'contexts', false);
// procedures
fn.appendObjects(config.objects.procedures, 'procedures', true);
// Post Install
fn.appendObjects(config.objects.postInstall, 'postInstall', true);

// todo see #NO OP Code in build.sh

[config.files.install, config.files.installNoop].forEach(file => {
  fn.fs.appendFile(file, `\nprompt Recompile logger_logs_terse since it depends on logger \n`);
  fn.fs.appendFile(file, `alter view logger_logs_terse compile;\n`);
})


// Replace any references for the version number
let installContents = fn.fs.readFile(config.files.install);
installContents = installContents.replace(/x\.x\.x/g, `${params.version.string}`);
fn.fs.writeFile(config.files.install, installContents);


// Generate uninstall file
fn.buildUninstall();

console.log(`Logger built`);

console.log(`Building Docs`);

exec(config.cmd.plmddoc, function (error, stdout, stderr) {
  // command output is in stdout
  if (error !== null) {
    console.log(`Error: ${error}`);
  }
});





