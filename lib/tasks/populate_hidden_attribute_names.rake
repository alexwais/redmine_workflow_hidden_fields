namespace :redmine do
  namespace :plugins do

    desc <<-END_DESC
        Populate hidden attribute names
    END_DESC

    task populate_hidden_attribute_names_by_role: :environment do
      Project.all.each do |project|
        Role.all.each do |role|

          result = []
          unless [role].empty?
            workflow_permissions = WorkflowPermission.where(:tracker_id => project.trackers.map(&:id), :old_status_id => IssueStatus.all.map(&:id), :role_id => role.id, :rule => 'hidden').all
            if workflow_permissions.any?
              workflow_rules = workflow_permissions.inject({}) do |hash, permission|
                hash[permission.field_name] ||= []
                hash[permission.field_name] << permission.rule
                hash
              end
              issue_statuses_count = IssueStatus.all.size
              workflow_rules.each do |attr, rules|
                result << attr if rules.size >= ([role].size * project.trackers.size * issue_statuses_count)
              end
            end
          end

          result += Tracker.disabled_core_fields(project.trackers)
          result += IssueCustomField.
              sorted.
              where("is_for_all = ? AND id NOT IN (SELECT DISTINCT cfp.custom_field_id" +
              " FROM #{project.table_name_prefix}custom_fields_projects#{project.table_name_suffix} cfp" +
              " WHERE cfp.project_id = ?)", false, project.id).pluck(:id).map(&:to_s)

          HiddenAttributeNamesByRole.find_or_create_by(name: result.join(';'), role_id: role.id)
        end
      end
    end
  end
end
