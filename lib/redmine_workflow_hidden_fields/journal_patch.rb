module RedmineWorkflowHiddenFields
  module  JournalPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method_chain :visible_details, :hidden
      end
    end

    module InstanceMethods

      # Returns journal details that are visible to user
      def visible_details_with_hidden(user=User.current)
        details.select do |detail|
          if detail.property == 'attr'
            !issue.hidden_attribute?(detail.prop_key, user)
          elsif detail.property == 'cf'
            detail.custom_field && detail.custom_field.visible_by?(project, user) && !issue.hidden_attribute?(detail.prop_key, user)
          elsif detail.property == 'relation'
            Issue.find_by_id(detail.value || detail.old_value).try(:visible?, user)
          else
            true
          end
        end
      end

    end
  end
end
