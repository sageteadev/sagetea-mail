%Dekkos Processes     {#architecture_processes}
=================

@startuml{processes.svg}

title Dekkos Processes

node "Dekkos processes" {

    package "[[architecture_dekko.html dekko]]\n[[https://gitlab.com/dekkan/dekko/-/tree/master/Dekko/app src://Dekko/app]]" as dekko {
    }

    package "dekko-worker\n[[https://gitlab.com/dekkan/dekko/-/tree/master/Dekko/server/serviceworker src://Dekko/server/serviceworker]]" as dekkoworker {
    }
 
    package "dekkod\n[[https://gitlab.com/dekkan/dekko/-/tree/master/Dekko/server src://Dekko/server]]" as dekkod {
    } 

    package "dekkod-notify\n[[https://gitlab.com/dekkan/dekko/-/tree/master/plugins/ubuntu-notification-plugin src://plugins/ubuntu-notification-plugin]]" as dekkodnotify {
    }
}

package "Upstart User Session" as upstart {
}

package "System Notification Center" as sysnotifcenter {
}

cloud "Mail server" as mailserver{
    [IMAP]
    [SMTP]
}


:User: --> dekko : starts, uses UI, suspends, closes
dekko --> dekkoworker : starts
dekko --> dekkod : restarts
dekko --> dekkodnotify : restarts
upstart --> dekkod : starts, stops
upstart --> dekkodnotify : starts, stops
dekkod --> mailserver : sends, fetches and syncs mail
dekkodnotify --> sysnotifcenter : displays notifications

@enduml

