module RedmineWorkflowHiddenFields
  def self.setup
    Issue.send(:prepend, RedmineWorkflowHiddenFields::IssuePatch)
    IssueQuery.send(:prepend, RedmineWorkflowHiddenFields::IssueQueryPatch)
    IssuesHelper.send(:prepend, RedmineWorkflowHiddenFields::IssuesHelperPatch)
    Journal.send(:prepend, RedmineWorkflowHiddenFields::JournalPatch)
    Project.send(:prepend, RedmineWorkflowHiddenFields::ProjectPatch)
    Query.send(:prepend, RedmineWorkflowHiddenFields::QueryPatch)
    QueryColumn.send(:prepend, RedmineWorkflowHiddenFields::QueryColumnPatch)
    QueryCustomFieldColumn.send(:prepend, RedmineWorkflowHiddenFields::QueryCustomFieldColumnPatch)
    WorkflowPermission.send(:include, RedmineWorkflowHiddenFields::WorkflowPermissionPatch)
    WorkflowsHelper.send(:prepend, RedmineWorkflowHiddenFields::WorkflowsHelperPatch)
    Redmine::Export::PDF::IssuesPdfHelper.send(:prepend, RedmineWorkflowHiddenFields::IssuesPdfHelperPatch)
  end
end
