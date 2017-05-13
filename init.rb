require 'redmine'

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'issue'
  Issue.send(:include, RedmineWorkflowHiddenFields::IssuePatch)
  require_dependency 'issue_query'
  IssueQuery.send(:include, RedmineWorkflowHiddenFields::IssueQueryPatch)
  require_dependency 'issues_helper'
  IssuesHelper.send(:include, RedmineWorkflowHiddenFields::IssuesHelperPatch)
  require_dependency 'journal'
  Journal.send(:include, RedmineWorkflowHiddenFields::JournalPatch)
  require_dependency 'project'
  Project.send(:include, RedmineWorkflowHiddenFields::ProjectPatch)
  require_dependency 'query'
  Query.send(:include, RedmineWorkflowHiddenFields::QueryPatch)
  QueryColumn.send(:include, RedmineWorkflowHiddenFields::QueryColumnPatch)
  QueryCustomFieldColumn.send(:include, RedmineWorkflowHiddenFields::QueryCustomFieldColumnPatch)
  require_dependency 'workflow_permission'
  WorkflowPermission.send(:include, RedmineWorkflowHiddenFields::WorkflowPermissionPatch)
  require_dependency 'workflows_helper'
  WorkflowsHelper.send(:include, RedmineWorkflowHiddenFields::WorkflowsHelperPatch)
  require_dependency 'redmine/export/pdf/issues_pdf_helper'
  Redmine::Export::PDF::IssuesPdfHelper.send(:include, RedmineWorkflowHiddenFields::IssuesPdfHelperPatch)
end

Redmine::Plugin.register :redmine_workflow_hidden_fields do
  requires_redmine :version_or_higher => '3.3.3'

  name 'Redmine Workflow Hidden Fields plugin'
  author 'Alexander Wais, David Robinson, et al.'
  description "Provides a 'hidden' issue field permission for workflows"
  version '0.3.0'
  url 'https://github.com/alexwais/redmine_workflow_hidden_fields'
  author_url 'http://www.redmine.org/issues/12005'
end
