module RedmineWorkflowHiddenFields
	module  JournalPatch
		# Returns journal details that are visible to user
		def visible_details(user=User.current)
			dets = super				
			dets.select do |detail|
				unless issue.nil?
					if detail.property == 'attr' or detail.property == 'cf'
						!issue.hidden_attribute?(detail.prop_key, user)
					else
						true
					end
				else
					true
				end
			end						
		end
	end
end