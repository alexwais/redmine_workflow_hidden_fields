module RedmineWorkflowHiddenFields
	module  QueryPatch
		def self.included(base)
			base.send(:include, InstanceMethods)
			base.class_eval do
				unloadable
				alias_method_chain :available_filters, :hidden
				alias_method_chain :add_custom_field_filter, :hidden
				alias_method_chain :columns, :hidden
				alias_method_chain :available_inline_columns, :hidden
				alias_method_chain :available_block_columns, :hidden
				alias_method_chain :groupable_columns, :hidden
				alias_method_chain :sortable_columns, :hidden
			end
		end


		module InstanceMethods
		
			def available_and_visible_columns
				available_columns.reject{|col| col.respond_to?(:custom_field) ? completely_hidden_fields.include?(col.custom_field.id.to_s) : completely_hidden_fields.include?(col.name)}
			end
			
			# Returns an array of columns that can be used to group the results
			def groupable_columns_with_hidden
				available_and_visible_columns.select {|c| c.groupable}
			end

			# Returns a Hash of columns and the key for sorting
			def sortable_columns_with_hidden
				available_and_visible_columns.inject({}) {|h, column|
					h[column.name.to_s] = column.sortable
					h
				}
			end

			def available_inline_columns_with_hidden
				available_and_visible_columns.select(&:inline?)
			end

			def available_block_columns_with_hidden
				available_and_visible_columns.reject(&:inline?)
			end  
		
		
			def columns_with_hidden
				columns_without_hidden.reject{|col| col.respond_to?(:custom_field) ? completely_hidden_fields.include?(col.custom_field.id.to_s) : completely_hidden_fields.include?(col.name)}				
			end
			
			def available_filters_with_hidden	  
				unless @available_filters
					available_filters_without_hidden
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

			def add_custom_field_filter_with_hidden(field, assoc=nil)
				unless completely_hidden_fields.include?(field.id.to_s)
					add_custom_field_filter_without_hidden(field, assoc)
				end
			end

		end
	end
end
