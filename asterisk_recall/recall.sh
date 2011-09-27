#!/usr/bin/expect

############################

if {[llength $argv] != 2} {
    send_user "Error: You must specify src and destination!\n"
    exit 1
}

set src [lindex $argv 0]
set dst [lindex $argv 1]

set username "admin"
set secret "xxxxxx"
set host "127.0.0.1"
set port "5038"

set channel "local/$src"
set context "default"
set priority "1"
set ring "__ALERT_INFO=Bellcore-r1"

############################

log_user 0

spawn telnet $host $port

expect_before eof {
    send_user "Failed to connect.\n"
    exit 1
}

expect "Manager" {
    send_user "Connected.\n"
    send "Action: Login\nUsername: $username\nSecret: $secret\n\n"
}

expect {
    -re "Response:\\s*Error" {
        send_user "Login failed.\n"
        exit 1
    }
    -re "Response:\\s*Success" {
        send_user "Logged in.\n"
        send "Action: Originate\nChannel: $channel\nContext: $context\nExten: $dst\nPriority: $priority\nVariable: $ring\n\n"
    }
}

send "Action: Logoff\n\n"
