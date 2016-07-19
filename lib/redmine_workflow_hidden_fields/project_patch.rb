module RedmineWorkflowHiddenFields
	module  ProjectPatch
		def self.included(base)
			base.send(:include, InstanceMethods)
			base.class_eval do
				unloadable
			end
		end

		module InstanceMethods

			# Returns list of attributes that are hidden on all statuses of all trackers for +user+ or the current user.
			def completely_hidden_attribute_names(user=User.current)
				roles = user.admin ? Role.all : user.roles_for_project(self)

				result = []
				unless roles.empty?
					workflow_permissions = WorkflowPermission.where(:tracker_id => trackers.map(&:id), :old_status_id => IssueStatus.all.select(:id), :role_id => roles.map(&:id), :rule => 'hidden').all
					if workflow_permissions.any?
						workflow_rules = workflow_permissions.inject({}) do |hash, permission|
							hash[permission.field_name] ||= []
							hash[permission.field_name] << permission.rule
							hash
						end
						workflow_rules.each do |attr, rules|
							result << attr if rules.size >= (roles.size * trackers.size * IssueStatus.all.count)
						end
					end
				else
					result = Tracker.core_fields(trackers)
					result << self.all_issue_custom_fields.pluck(:id).map {|id| id.to_s}
				end


				result += Tracker.disabled_core_fields(trackers)

				result += IssueCustomField.
					  sorted.
					  where("is_for_all = ? AND id NOT IN (SELECT DISTINCT cfp.custom_field_id" +
						" FROM #{table_name_prefix}custom_fields_projects#{table_name_suffix} cfp" +
						" WHERE cfp.project_id = ?)", false, id).pluck(:id).map {|id| id.to_s}
				result
			end

		end
	end
end
