module RedmineWorkflowHiddenFields
	module  JournalPatch
		# Returns journal details that are visible to user
		def visible_details(user=User.current)
			unless issue.nil?
				dets = super				
				dets.select do |detail|
					if detail.property == 'attr' or detail.property == 'cf'
						!issue.hidden_attribute?(detail.prop_key, user)
					else
						true
					end
				end
			else
				super
			end						
		end
	end
end
