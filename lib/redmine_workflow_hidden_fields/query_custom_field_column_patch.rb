module RedmineWorkflowHiddenFields
	module  QueryCustomFieldColumnPatch
		def self.included(base)
			base.send(:include, InstanceMethods)
			base.class_eval do
				unloadable
				alias_method_chain :value_object, :hidden
			end
		end

		module InstanceMethods
			def visible?(object)
				if object.respond_to?(:hidden_attribute_names)  
					hidden_fields = object.hidden_attribute_names.map {|field| field.sub(/_id$/, '')}
					!hidden_fields.include?(custom_field.id.to_s)
				else
					true
				end	
			end
			
			def value_object_with_hidden(object)												
				if custom_field.visible_by?(object.project, User.current) and visible?(object)
					cv = object.custom_values.select {|v| v.custom_field_id == @cf.id}.uniq
					cv.size > 1 ? cv.sort {|a,b| a.value.to_s <=> b.value.to_s} : cv.first
				else
					nil
				end
			end			
		end
	end
end
