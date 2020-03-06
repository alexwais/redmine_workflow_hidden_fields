module RedmineWorkflowHiddenFields
	module  QueryColumnPatch
		
		def value(object)    
			if object.respond_to?(:hidden_attribute_names)  
				hidden_fields = object.hidden_attribute_names.map {|field| field.sub(/_id$/, '')}  
				if hidden_fields.include?(name.to_s)  
					""
				else  
					object.send name
				end  
			else  
				object.send name
			end 		
		end

	end
end
