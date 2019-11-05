module RedmineWorkflowHiddenFields
  module  IssueQueryPatch
    def self.included(base)
      base.class_eval do
	unloadable # Send unloadable so it will not be unloaded in development
	alias_method :available_filters_without_patch, :available_filters
	alias_method :available_filters, :available_filters_with_patch
        
	alias_method :available_columns_without_patch, :available_columns
	alias_method :available_columns, :available_columns_with_patch
      end
    end
    
    def available_columns_with_patch
      unless @available_columns
	@available_columns = available_columns_without_patch
	fields = completely_hidden_fields.map {|field| field.sub(/_id$/, '')}  
        
	@available_columns.reject! {|column|
	  fields.include?(column.name.to_s)
	} 
      end
      @available_columns
    end
    
    
    def available_filters_with_patch
      unless @available_filters				
	@available_filters = available_filters_without_patch
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
