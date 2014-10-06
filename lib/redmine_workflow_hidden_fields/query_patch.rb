module RedmineWorkflowHiddenFields
  module  QueryPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method_chain :available_filters, :hidden
        alias_method_chain :add_custom_field_filter, :hidden
      end
    end


    module InstanceMethods

      def available_filters_with_hidden
        unless @available_filters
          initialize_available_filters
          @available_filters.each do |field, options|
            options[:name] ||= l(options[:label] || "field_#{field}".gsub(/_id$/, ''))
          end
        end
        hidden_fields.each {|field|
          @available_filters.delete field
        }
        @available_filters
      end

      def hidden_fields 
        return @hidden_fields if @hidden_fields  
        if project != nil 
          @hidden_fields = project.completely_hidden_attribute_names 
        else 
          @hidden_fields = [] 
          usr = User.current; 
          first = true 
          all_projects.each { |prj| 
            if prj.visible? and usr.roles_for_project(prj).count > 0 
              if first 
                @hidden_fields = prj.completely_hidden_attribute_names(usr) 
              else 
                @hidden_fields &= prj.completely_hidden_attribute_names(usr) 
              end 
              return @hidden_fields if @hidden_fields.empty? 
            end 
            first = false 
          } 
        end 
        return @hidden_fields 
      end

      def add_custom_field_filter_with_hidden(field, assoc=nil)
        unless hidden_fields.include?(field.id.to_s)
         add_custom_field_filter_without_hidden(field, assoc)
        end
      end

    end
  end
end
