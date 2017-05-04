redmine_workflow_hidden_fields
==============================

This plugin adds a new 'Hidden' permission to the existing 'Read-only' and 'Required' permissions for issue fields, which are configurable per workflow.

Corresponding issue on redmine.org: [#12005](http://www.redmine.org/issues/12005)


###Features

- Configure hidden fields in workflows, thus per status and roles.

- Hidden fields don't show up for respective users on issues (views, table, forms, history), exported .csv and .pdf files.

- Completely hidden fields (fields that are configured to not be visible anywhere for the user) are removed from available columns & filters.


###Compatibility

The plugin was developed and tested with Redmine version 3.3.3-stable.


###Installation

- Put the plugin folder into your Redmine's /plugin directory.

- Restart your Redmine.


###License

GNU General Public License Version 2

