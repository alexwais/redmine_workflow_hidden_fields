require 'redmine'

Rails.configuration.to_prepare do
#ActiveSupport::Reloader.to_prepare do
  require_dependency 'issue'
  Issue.send(:prepend, RedmineWorkflowHiddenFields::IssuePatch)
  require_dependency 'issue_query'
  IssueQuery.send(:prepend, RedmineWorkflowHiddenFields::IssueQueryPatch)
  require_dependency 'issues_helper'
  IssuesHelper.send(:prepend, RedmineWorkflowHiddenFields::IssuesHelperPatch)
  require_dependency 'journal'
  Journal.send(:prepend, RedmineWorkflowHiddenFields::JournalPatch)
  require_dependency 'project'
  Project.send(:prepend, RedmineWorkflowHiddenFields::ProjectPatch)
  require_dependency 'query'
  Query.send(:prepend, RedmineWorkflowHiddenFields::QueryPatch)
  QueryColumn.send(:prepend, RedmineWorkflowHiddenFields::QueryColumnPatch)
  QueryCustomFieldColumn.send(:prepend, RedmineWorkflowHiddenFields::QueryCustomFieldColumnPatch)
  require_dependency 'workflow_permission'
  WorkflowPermission.send(:include, RedmineWorkflowHiddenFields::WorkflowPermissionPatch)
  require_dependency 'workflows_helper'
  WorkflowsHelper.send(:prepend, RedmineWorkflowHiddenFields::WorkflowsHelperPatch)
  require_dependency 'redmine/export/pdf/issues_pdf_helper'
  Redmine::Export::PDF::IssuesPdfHelper.send(:prepend, RedmineWorkflowHiddenFields::IssuesPdfHelperPatch)
end

Redmine::Plugin.register :redmine_workflow_hidden_fields do
  requires_redmine :version_or_higher => '3.4.0'

  name 'Redmine Workflow Hidden Fields plugin'
  author 'Alexander Wais, David Robinson, et al.'
  description "Provides a 'hidden' issue field permission for workflows"
  version '0.5.0'
  url 'https://github.com/alexwais/redmine_workflow_hidden_fields'
  author_url 'http://www.redmine.org/issues/12005'
end
