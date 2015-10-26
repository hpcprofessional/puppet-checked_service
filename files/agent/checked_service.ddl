metadata :name        => "checked_service tools",
         :description => "Stops and provides status on a set of services",
         :author      => "PuppetLabs Professional Services",
         :license     => "None",
         :version     => "1.0",
         :url         => "None",
         :timeout     => 60

action "stopall", :description => "Stops a set of services" do
     display :always

     output :message,
            :description => "Response after attempting to stop",
            :display_as  => "puppet output"
end

action "status", :description => "Reports status on a set of services" do
     display :always

     output :message,
            :description => "Response with status",
            :display_as  => "puppet output"
end
