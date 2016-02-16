# Use this file instead of `rails/all` in order to load the gulp pipeline instead of sprockets

require 'rails'

%w(
  active_record
  action_controller
  action_view
  action_mailer
  active_job
  rails/test_unit
  gulp/pipeline/rails
).each do |framework|
  begin
    require "#{framework}/railtie"
  rescue LoadError
  end
end
