module RedmineWorkflowHiddenFields
	module  IssueQueryPatch
		def self.included(base)
			base.send(:include, InstanceMethods)
			base.class_eval do
				unloadable
				#alias_method_chain :initialize_available_filters, :hidden
				alias_method_chain :available_columns, :hidden
				alias_method_chain :available_filters, :hidden
			end
		end

		module InstanceMethods

			def available_columns_with_hidden
				unless @available_columns
					@available_columns = available_columns_without_hidden
					fields = completely_hidden_fields.map {|field| field.sub(/_id$/, '')}  

					@available_columns.reject! {|column|
						fields.include?(column.name.to_s)
					} 
				end
				@available_columns
			end
			

			def available_filters_with_hidden
				unless @available_filters				
					@available_filters = available_filters_without_hidden
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
end
