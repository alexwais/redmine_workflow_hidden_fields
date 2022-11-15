module RedmineWorkflowHiddenFields
  module  WorkflowPermissionPatch
    def self.included(base)
      base.class_eval do
        # The filters are part of validators are raw, they can be skipped with the following way.
        rule_inclusion_validation = base._validators[:rule].find{ |validator| validator.is_a? ActiveModel::Validations::InclusionValidator }
        base._validators[:rule].delete(rule_inclusion_validation)
        filter = base._validate_callbacks.find{ |c| c.raw_filter == rule_inclusion_validation }.filter
        skip_callback :validate, filter

        validates_inclusion_of :rule, :in => %w(readonly required hidden)
        after_commit :update_hidden_attribute_names
      end
    end

    def update_hidden_attribute_names
      HiddenAttributeNamesJob.perform_later
    end
  end
end
