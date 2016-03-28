app_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift(app_path) unless $LOAD_PATH.include?(app_path)

require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end
  every(1.day, 'Send past due date email', at: '00:00') { Lease.notify_past_due_date }
  every(1.day, 'Send near due date alert', at: '00:00') { Lease.notify_near_due_date }
end
