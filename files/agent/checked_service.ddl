# This file provides metadata on the checked_service MCollective agent, so that
# help documentation can be automatically generated for this agent.
#
# For more on writing DDL files, see here:
#  https://docs.puppetlabs.com/mcollective/reference/plugins/ddl.html

# Overall metadata for the agent.
metadata :name        => "checked_service tools",
         :description => "Stops and provides status on a set of services",
         :author      => "PuppetLabs Professional Services",
         :license     => "None",
         :version     => "1.0",
         :url         => "None",
         :timeout     => 60

# Data Definition for the 'stopall' action.
action "stopall", :description => "Stops a set of services" do
     display :always

     output :message,
            :description => "Response after attempting to stop",
            :display_as  => "puppet output"
end

# Data Definition for the 'status' action.
action "status", :description => "Reports status on a set of services" do
     display :always

     output :message,
            :description => "Response with status",
            :display_as  => "puppet output"
end
