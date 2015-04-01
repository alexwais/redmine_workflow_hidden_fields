
module RedmineWorkflowHiddenFields
  module  WorkflowsHelperPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method_chain :field_permission_tag, :hidden
      end
    end

    module InstanceMethods

        def field_permission_tag_with_hidden(permissions, status, field, roles)
            name = field.is_a?(CustomField) ? field.id.to_s : field
            options = [["", ""], [l(:label_readonly), "readonly"]]
            options << [l(:label_hidden), "hidden"]
            options << [l(:label_required), "required"] unless field_required?(field)
            html_options = {}

            if perm = permissions[status.id][name]
              if perm.uniq.size > 1 || perm.size < @roles.size * @trackers.size
                options << [l(:label_no_change_option), "no_change"]
                selected = 'no_change'
              else
                selected = perm.first
              end
            end

            hidden = field.is_a?(CustomField) &&
              !field.visible? &&
              !roles.detect {|role| role.custom_fields.to_a.include?(field)}

            if hidden
              options[0][0] = l(:label_hidden)
              selected = ''
              html_options[:disabled] = true
            end

            select_tag("permissions[#{status.id}][#{name}]", options_for_select(options, selected), html_options)
        end

    end
  end
end
