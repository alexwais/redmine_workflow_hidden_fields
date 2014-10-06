module RedmineWorkflowHiddenFields
  module  QueryPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
      end
    end

    module InstanceMethods

      def value(object)    
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

      def available_filters
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

      def add_custom_field_filter(field, assoc=nil)
        unless hidden_fields.include?(field.id.to_s)
          options = field.format.query_filter_options(field, self)
          if field.format.target_class && field.format.target_class <= User
            if options[:values].is_a?(Array) && User.current.logged?
              options[:values].unshift ["<< #{l(:label_me)} >>", "me"]
            end
          end

          filter_id = "cf_#{field.id}"
          filter_name = field.name
          if assoc.present?
            filter_id = "#{assoc}.#{filter_id}"
            filter_name = l("label_attribute_of_#{assoc}", :name => filter_name)
          end
          add_available_filter filter_id, options.merge({
            :name => filter_name,
            :field => field
            })
        end
      end

    end
  end
end
