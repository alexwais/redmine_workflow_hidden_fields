module RedmineWorkflowHiddenFields
	module  ProjectPatch

		# Returns list of attributes that are hidden on all statuses of all trackers for +user+ or the current user.
		def completely_hidden_attribute_names(user=User.current)
			roles = user.admin ? Role.all : user.roles_for_project(self)
			HiddenAttributeNamesByRole.where(role_id: roles).pluck(:name).map{ |r| r.split(';')}.flatten
		end
	end
end
