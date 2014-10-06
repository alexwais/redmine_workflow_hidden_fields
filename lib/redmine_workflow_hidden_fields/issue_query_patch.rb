module RedmineWorkflowHiddenFields
  module  IssueQueryPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        #alias_method_chain :initialize_available_filters, :hidden
        alias_method_chain :available_columns, :hidden
      end
    end

    module InstanceMethods

      def available_columns_with_hidden

        @available_columns = available_columns_without_hidden

        if project == nil
          hidden_fields = []
          all_projects.each { |prj| 
            if prj.visible? and User.current.roles_for_project(prj).count > 0
              hidden_fields = hidden_fields == [] ? prj.completely_hidden_attribute_names : hidden_fields & prj.completely_hidden_attribute_names
            end
          }
        else
          hidden_fields = project.completely_hidden_attribute_names
        end
        hidden_fields.map! {|field| field.sub(/_id$/, '')}  

          @available_columns.reject! {|column|
            hidden_fields.include?(column.name.to_s)
          } 

          @available_columns
      end




    end
  end
end
