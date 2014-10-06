module RedmineWorkflowHiddenFields
  module  QueryColumnPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method_chain :value, :hidden
      end
    end

    module InstanceMethods

      def value_with_hidden(object)    
        object.send name  
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
end
