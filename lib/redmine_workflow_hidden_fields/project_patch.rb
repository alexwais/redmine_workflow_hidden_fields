module RedmineWorkflowHiddenFields
  module  ProjectPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
      end
    end

    module InstanceMethods

      # Returns list of attributes that are hidden on all statuses of all trackers for +user+ or the current user. 
      def completely_hidden_attribute_names(user=nil) 
        user_real = user || User.current 
        roles = user_real.admin ? Role.all : user_real.roles_for_project(self) 
        return {} if roles.empty?  
        result = {} 
        workflow_permissions = WorkflowPermission.where(:tracker_id => trackers.map(&:id), :old_status_id => IssueStatus.all.map(&:id), :role_id => roles.map(&:id), :rule => 'hidden').all  if workflow_permissions.any? 
        workflow_rules = workflow_permissions.inject({}) do |h, wp| 
          h[wp.field_name] ||= [] 
          h[wp.field_name] << wp.rule 
          h 
        end 
        workflow_rules.each do |attr, rules| 
          next if rules.size < (roles.size * trackers.size * IssueStatus.all.size) 
          uniq_rules = rules.uniq 
          if uniq_rules.size == 1 
            result[attr] = uniq_rules.first 
          else 
            result[attr] = 'required' 
          end 
        end 
        result.keys     
      end  

    end
  end
end
