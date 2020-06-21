# MS Visual Studio Code Build Tasks

- [Setup](#setup)
- [Tasks](#tasks)

*The `.vscode` template and scripts were copied from the [Starter Project Template](https://github.com/insum-labs/starter-project-template/). Please see the started template for full documentation about how all the scripts work etc.*

These scripts are meant to help **developers** while developing Logger and are **not** meant to be used to do a "regular" install.

## Setup

The first time you execute this script an error will be shown and `scripts/user-config.sh` will be created with some default values. Modify the variables as necessary.

*Note: Windows users: Please ensure WSL or cmder is configured to run bash as terminal in VSC: [instructions](../README.md#windows-setup)*

## Tasks

Tasks can be executed with `⌘+shift+B` and selecting the desired task. Example:

![Task Compile Demo](img/task-compile.gif)

Task Name | Description 
--- | ---
`oos-logger: compile file` | Compile the current file in VSC
`oos-logger: install` | Install Logger. Useful when testing build and install scripts
`oos-logger: uninstall` | Uninstall Logger
`oos-logger: logger_configure` | Runs `logger_configure;` Knonw issue when running `logger_configure;` twice in same DB session to raise an `ORA-600` (unknown error). 
