module RedmineWorkflowHiddenFields
  module  IssuePatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method_chain :safe_attribute_names, :hidden
      end
    end

    module InstanceMethods

      def visible_custom_field_values(user=nil)
        user_real = user || User.current
        fields = custom_field_values.select do |value|
          value.custom_field.visible_by?(project, user_real) 
        end
        fields = fields & viewable_custom_field_values(user_real)
        fields
      end


      # Returns the custom_field_values that can be viewed by the given user
      # For now: just exclude Fix Info and RNs, as it is printed seperately below description.
      def viewable_custom_field_values(user=nil)
        custom_field_values.reject do |value|
          hidden_attribute_names(user).include?(value.custom_field_id.to_s)
        end
      end 


      def read_only_attribute_names(user=nil)
        workflow_rule_by_attribute(user).reject {|attr, rule| rule != 'readonly' and rule != 'hidden'}.keys
      end


      # Same as above, but for hidden fields
      def hidden_attribute_names(user=nil)
        workflow_rule_by_attribute(user).reject {|attr, rule| rule != 'hidden'}.keys
      end


      # Returns true if the attribute should be hidden for user
      def hidden_attribute?(name, user=nil)
        hidden_attribute_names(user).include?(name.to_s)
      end  


      def each_notification(users, &block)
        if users.any?
         variations = users.collect {
          |user| (hidden_attribute_names(user) + (custom_field_values - visible_custom_field_values(user))).uniq
          }.uniq
          recipient_groups = Array.new(variations.count) { Array.new }
          users.each do |user|
            recipient_groups[variations.index(hidden_attribute_names(user))] << user
          end
          recipient_groups.each do |group|
            yield(group)
          end
        end 
      end

      def safe_attribute_names_with_hidden(user=nil)
        names = safe_attribute_names_without_hidden
        names -= hidden_attribute_names(user)
        names
      end

    end
  end
end
