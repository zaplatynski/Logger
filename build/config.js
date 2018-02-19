// Storing config in a .js file to have ability to comment
var
  objects = {},
  files = {
    install : '../install/logger_install.sql',
    uninstall: '../install/logger_uninstall.sql'
  }
;


// Contexts
objects.contexts = [
  {
    name: 'logger_context',
    src: '../contexts/logger_context.sql'
  }
];

// Jobs
objects.jobs = [
  {
    name: 'logger_purge_job',
    src: '../jobs/logger_purge_job.sql'
  },
  {
    name: 'logger_unset_prefs_by_client',
    src: '../jobs/logger_unset_prefs_by_client.sql'
  }
];

// Packages
objects.packages = [
  {
    name: 'logger',
    src: '../packages/logger.pks'
  },
  {
    name: 'logger',
    src: '../packages/logger.pkb'
  }
];

// Post Install
objects.postInstall = [
  {
    name: 'post_install_configuration',
    src: '../scripts/install/post_install_configuration.sql'
  }
];

// Pre Install
objects.preInstall = [
  {
    name: 'logger_install_prereqs',
    src: '../scripts/install/prereqs_install.sql'
  }
];

// Procedures
objects.procedures = [
  {
    name: 'logger_configure',
    src: '../procedures/logger_configure.plb'
  }
];

// Pre Install
objects.sequences = [
  {
    name: 'logger_logs_seq',
    src: '../sequences/logger_logs_seq.sql'
  },
  {
    name: 'logger_apx_items_seq',
    src: '../sequences/logger_apx_items_seq.sql'
  }
];


// Tables
objects.tables = [
  {
    name: 'logger_logs',
    src: '../tables/logger_logs.sql',
    dropOrder: 3
  },
  {
    name: 'logger_prefs',
    src: '../tables/logger_prefs.sql',
    dropOrder: 2
  },
  {
    name: 'logger_logs_apex_items',
    src: '../tables/logger_logs_apex_items.sql',
    dropOrder: 1
  },
  {
    name: 'logger_prefs_by_client_id',
    src: '../tables/logger_prefs_by_client_id.sql',
    dropOrder: 4
  }
];


// Views
objects.views = [
  {
    name: 'logger_logs_5_min',
    src: '../views/logger_logs_5_min.sql'
  },
  {
    name: 'logger_logs_60_min',
    src: '../views/logger_logs_60_min.sql'
  },
  {
    name: 'logger_logs_terse',
    src: '../views/logger_logs_terse.sql'
  }
];


module.exports.objects = objects;
module.exports.files = files;
