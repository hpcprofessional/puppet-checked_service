metadata :name => "checked_service",
         :description => "%DESCRIPTION%",
         :author => "%AUTHOR%",
         :license => "%LICENSE%",
         :version => "%VERSION%",
         :url => "%URL%",
         :timeout => %TIMEOUT%

action "stopall", :description => "%ACTIONDESCRIPTION%" do
     # Example Input
     input :name,
           :prompt => "%PROMPT%",
           :description => "%DESCRIPTION%",
           :type => %TYPE%,
           :validation => '%VALIDATION%',
           :optional => %OPTIONAL%,
           :maxlength => %MAXLENGTH%

     # Example output
     output :name,
            :description => "%DESCRIPTION%",
            :display_as => "%DISPLAYAS%"
end

action "status", :description => "%ACTIONDESCRIPTION%" do
end
