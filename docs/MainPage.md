%Developer documentation                        {#mainpage}
=============

First steps
---------------------

  * @subpage dev_setup
  * @subpage dev_bugs
  * @subpage dev_codestyle

Specs
---------

  * [Online Accounts](specs/OA.md)
  * [Autoconfig ISPDB](specs/autoconfig.md)
  * [XUBUNTUPUSH](specs/xubuntupush.md)

@todo turn these into subpages

Architecture
---------------

@startuml

node "Dekko App" {
    package "Ubuntu UI plugin (upstream/ubuntu-plugin)" {
        [Mail (plugins/core/mail)] <--> DekkoUmlApi 
        [Settings (plugins/core/settings)] <--> DekkoUmlApi 
    }
    [Quickflux] <--> MailServiceInterface.cpp
}
 
node "dekkod (Dekko/server)" {
    MailServiceWorker.cpp <--> [qt messaging framework (upstream/qmf)]
} 

node "dekkod-notifications" {
}

cloud {
    [DBus]
}

cloud "MailServer" {
    [IMAP]
    [SMTP]
}


[MailServiceInterface.cpp] <--> [DBus]
[DBus] <--> [MailServiceWorker.cpp]
[DekkoUmlApi] <--> [Quickflux]
[qt messaging framework (upstream/qmf)] <-- [IMAP]
[qt messaging framework (upstream/qmf)] --> [SMTP]

@enduml


Designs
-----------

@todo Link up design images
