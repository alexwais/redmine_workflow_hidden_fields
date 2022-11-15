namespace :redmine do
  namespace :plugins do

    desc <<-END_DESC
        Populate hidden attribute names
    END_DESC

    task populate_hidden_attribute_names_by_role: :environment do
      HiddenAttributeNamesService.call
    end
  end
end
