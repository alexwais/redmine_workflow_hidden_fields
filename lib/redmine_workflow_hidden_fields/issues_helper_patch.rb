module RedmineWorkflowHiddenFields
	module  IssuesHelperPatch
		def self.included(base)
			base.send(:include, InstanceMethods)
			base.class_eval do
				unloadable
				alias_method_chain :email_issue_attributes, :hidden
				alias_method_chain :details_to_strings, :hidden
			end
		end

		module InstanceMethods

			def email_issue_attributes_with_hidden(issue, user)
				items = []
				%w(author status priority assigned_to category fixed_version).each do |attribute|
					unless issue.disabled_core_fields.include?(attribute+"_id") or issue.hidden_attribute_names(user).include?(attribute+"_id")
						items << "#{l("field_#{attribute}")}: #{issue.send attribute}"
					end
				end
				issue.visible_custom_field_values(user).reject { |value| value.custom_field.field_format == 'label' || value.custom_field.field_format == 'grid' }.each do |value|
					items << "#{value.custom_field.name}: #{show_value(value, false)}"
				end
				items
			end

			def details_to_strings_with_hidden(details, no_html=false, options={})
        options[:only_path] = (options[:only_path] == false ? false : true)
        strings = []
        values_by_field = {}
        details.each do |detail|
          if detail.property == 'cf' && (!detail.journal || !detail.journal.issue.hidden_attribute?(detail.prop_key, options[:user]))
            field = detail.custom_field
            if field && field.multiple?
              values_by_field[field] ||= {:added => [], :deleted => []}
              if detail.old_value
                values_by_field[field][:deleted] << detail.old_value
              end
              if detail.value
                values_by_field[field][:added] << detail.value
              end
              next
            end
          end
          strings << show_detail(detail, no_html, options)
        end
        if values_by_field.present?
          multiple_values_detail = Struct.new(:property, :prop_key, :custom_field, :old_value, :value)
          values_by_field.each do |field, changes|
            if !details.first.journal || !details.first.journal.issue.hidden_attribute?(field.id.to_s, options[:user])
              if changes[:added].any?
                detail = multiple_values_detail.new('cf', field.id.to_s, field)
                detail.value = changes[:added]
                strings << show_detail(detail, no_html, options)
              end
              if changes[:deleted].any?
                detail = multiple_values_detail.new('cf', field.id.to_s, field)
                detail.old_value = changes[:deleted]
                strings << show_detail(detail, no_html, options)
              end
            end
          end
        end
        strings
			end
		end
	end
end
