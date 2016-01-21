module RedmineWorkflowHiddenFields
	module  JournalPatch
		def self.included(base)
			base.send(:include, InstanceMethods)
			base.class_eval do
				unloadable
				alias_method_chain :visible_details, :hidden
			end
		end

		module InstanceMethods
			# Returns journal details that are visible to user
			def visible_details_with_hidden(user=User.current)
				dets = visible_details_without_hidden(user)				
				dets.select do |detail|
					if detail.property == 'attr' or detail.property == 'cf'
						!issue.hidden_attribute?(detail.prop_key, user)
					else
						true
					end
                end						
			end
		end
	end
end