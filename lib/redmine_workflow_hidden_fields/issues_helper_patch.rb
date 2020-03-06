module RedmineWorkflowHiddenFields
	module  IssuesHelperPatch

		def email_issue_attributes(issue, user, html)
			items = []
			%w(author status priority assigned_to category fixed_version).each do |attribute|
				unless issue.disabled_core_fields.include?(attribute+"_id") or issue.hidden_attribute_names(user).include?(attribute+"_id")
					if html
						items << content_tag('strong', "#{l("field_#{attribute}")}: ") + (issue.send attribute)
					else
						items << "#{l("field_#{attribute}")}: #{issue.send attribute}"
					end
				end
			end
			issue.visible_custom_field_values(user).each do |value|
				if html
					items << content_tag('strong', "#{value.custom_field.name}: ") + show_value(value, false)
				else
					items << "#{value.custom_field.name}: #{show_value(value, false)}"
				end
			end
			items
		end

		def details_to_strings(details, no_html=false, options={})	
			options[:only_path] = (options[:only_path] == false ? false : true)
			strings = []
			values_by_field = {}
			details.each do |detail|
				unless (detail.property == 'cf' || detail.property == 'attr') &&  detail.journal.issue.hidden_attribute?(detail.prop_key, options[:user])
					if detail.property == 'cf'
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
			end
			if values_by_field.present?
				values_by_field.each do |field, changes|
					unless details.first.journal.issue.hidden_attribute?(field.id.to_s, options[:user])						
						if changes[:added].any?
							detail = MultipleValuesDetail.new('cf', field.id.to_s, field)
							detail.value = changes[:added]
							strings << show_detail(detail, no_html, options)
						end
						if changes[:deleted].any?
							detail = MultipleValuesDetail.new('cf', field.id.to_s, field)
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


	
