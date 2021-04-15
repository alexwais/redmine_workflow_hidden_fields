module RedmineWorkflowHiddenFields
	module  QueryPatch
		
		def available_and_visible_columns
			available_columns.reject{|col| col.respond_to?(:custom_field) ? completely_hidden_fields.include?(col.custom_field.id.to_s) : completely_hidden_fields.include?(col.name)}
		end
		
		# Returns an array of columns that can be used to group the results
		def groupable_columns
			available_and_visible_columns.select {|c| c.groupable?}
		end

		# Returns a Hash of columns and the key for sorting
		def sortable_columns
			available_and_visible_columns.inject({}) {|h, column|
				h[column.name.to_s] = column.sortable
				h
			}
		end

		def available_inline_columns
			available_and_visible_columns.select(&:inline?)
		end

		def available_block_columns
			available_and_visible_columns.reject(&:inline?)
		end  
	
		def columns
			super.reject{|col| col.respond_to?(:custom_field) ? completely_hidden_fields.include?(col.custom_field.id.to_s) : completely_hidden_fields.include?(col.name)}				
		end
		
		def available_filters	  
			unless @available_filters
				super
				completely_hidden_fields.each {|field|
					@available_filters.delete field
				}					
			end
			@available_filters				
		end

		def completely_hidden_fields 
			unless @completely_hidden_fields  
				if project != nil 
					@completely_hidden_fields = project.completely_hidden_attribute_names 
				else 
					@completely_hidden_fields = [] 
					usr = User.current; 
					first = true
					all_projects.each { |prj|
						if usr.roles_for_project(prj).count > 0 
							if first 
								@completely_hidden_fields = prj.completely_hidden_attribute_names(usr) 
							else 
								@completely_hidden_fields &= prj.completely_hidden_attribute_names(usr) 
							end 
							return @completely_hidden_fields if @completely_hidden_fields.empty? 
							first = false 								
						end 
					} 
				end
			end				
			return @completely_hidden_fields 
		end

		# Adds a filter for the given custom field
		def add_custom_field_filter(field, assoc=nil)
			unless completely_hidden_fields.include?(field.id.to_s)
				super
			end
		end

	end
end
