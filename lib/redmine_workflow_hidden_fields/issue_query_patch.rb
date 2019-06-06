module RedmineWorkflowHiddenFields
	module  IssueQueryPatch
		def available_columns
			unless @available_columns
				@available_columns = super
				fields = completely_hidden_fields.map {|field| field.sub(/_id$/, '')}  

				@available_columns.reject! {|column|
					fields.include?(column.name.to_s)
				} 
			end
			@available_columns
		end
		

		def available_filters
			unless @available_filters				
				@available_filters = super
				completely_hidden_fields.each {|field|
					delete_available_filter field
					if field == "assigned_to_id" then
						delete_available_filter "assigned_to_role"
					end
					if field == "assigned_to_id" then
						delete_available_filter "member_of_group"
					end
				}					
			end
			@available_filters
		end
	end
end
