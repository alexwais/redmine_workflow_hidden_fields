redmine_workflow_hidden_fields
==============================

This plugin adds a new 'Hidden' permission to the existing 'Read only' and 'Required' permissions for issue fields, which are configurable per workflow.

Corresponding issue on redmine.org: [#12005](http://www.redmine.org/issues/12005)


##Compatibility

This plugin was developed and tested with Redmine version 2.5.2.

##Installation

- Put the plugin folder into your Redmine installation's /plugin directory.
- Edit the file /app/models/workflow_permission.rb inside your Redmine installation:

Change line 19 from `validates_inclusion_of :rule, :in => %w(readonly required)` to
`validates_inclusion_of :rule, :in => %w(readonly required hidden)` and save that file.

- Restart your Redmine.
