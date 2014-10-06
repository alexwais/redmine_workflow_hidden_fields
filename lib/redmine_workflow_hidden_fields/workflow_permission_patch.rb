module RedmineWorkflowHiddenFields
  module  WorkflowPermissionPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      #base.extend(ClassMethods)
      base.class_eval do

        # HACK: Remove the existing validates_uniqueness_of block
       #

        # Add new validates_uniqueness_of with correct scope
        #validates_uniqueness_of :name, :case_sensitive => false, :scope => :site_id
      


        #validates_inclusion_of :rule, :in => %w(readonly required hidden)
        _validators.reject!{ |key, _| key == :rule }
        
        #_validate_callbacks.reject! do |callback|
        #  callback.raw_filter.attributes == [:rule]
        #end
      end
    end

    module InstanceMethods

    end
  end
end
