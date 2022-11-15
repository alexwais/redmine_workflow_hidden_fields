class HiddenAttributeNamesJob < ApplicationJob
  def perform
    p 'Running script ...'
    HiddenAttributeNamesService.call
  end
end
