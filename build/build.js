const 
  fn = require('./fn.js'),
  config = require('./config.js'),
  path = require('path'),
  fs = require('fs')
;


// Parameters
let params = fn.getParameters();


// TODO mdsouza: no-op
// TODO mdsouza: drop objects


// for (file in config.files) {
//   fn.writeFile(config.files[file], '');
// }

console.log(config.installPath);

// Clear Install directory
let files = fs.readdirSync(path.resolve(__dirname, config.installPath));

files.forEach(function(myFile){
  // As part of new install restructure (#194) be safe to explicitly list files to delete
  if (myFile === 'logger_install.sql') { 
    fs.unlinkSync(path.resolve(__dirname, config.installPath, myFile));
  }
});


fn.fs.writeFile(config.files.install, '');


// Pre Install
fn.appendObjects(config.objects.preInstall, 'prereqs', true);

// TODO mdsouza: noop prompts (see build.sh)

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



// Recompile logger_prefs trigger as it has dependencies on logger.pks
// TODO mdsouza: go to noop as well
fn.fs.appendFile(config.files.install, `\nprompt Recompile biu_logger_prefs after logger.pkb \n`);
fn.fs.appendFile(config.files.install, `alter trigger biu_logger_prefs compile;\n`);

// contexts
fn.appendObjects(config.objects.contexts, 'contexts', false);
// procedures
fn.appendObjects(config.objects.procedures, 'procedures', false);
// Post Install
fn.appendObjects(config.objects.postInstall, 'postInstall', false);

// todo see #NO OP Code in build.sh

fn.fs.appendFile(config.files.install, `\nprompt Recompile logger_logs_terse since it depends on logger \n`);
fn.fs.appendFile(config.files.install, `alter view logger_logs_terse compile;\n`);


// Replace any references for the version number
let installContents = fn.fs.readFile(config.files.install);
installContents = installContents.replace(/x\.x\.x/g, `${params.version.major}.${params.version.minor}.${params.version.patch}`);
fn.fs.writeFile(config.files.install, installContents);


// TODO Drops
// whenever sqlerror continue
// packages
// procedures

// tables (need to go in this order;)
//   logger_logs_apex_items cascade constraints
//   logger_prefs cascade constraints
//   table logger_logs cascade constraints
//   table logger_prefs_by_client_id cascade constraints

// Sequences (Not sure where we call these)

// Jobs: (run one at a time)
// dbms_scheduler.drop_job('LOGGER_PURGE_JOB');
// dbms_scheduler.drop_job('LOGGER_UNSET_PREFS_BY_CLIENT');

// Views


