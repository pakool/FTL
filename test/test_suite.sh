#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
# load 'libs/bats-assert/load'

@test "Version" {
  run bash -c 'echo ">version >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
  [[ ${lines[1]} =~ "version" ]]
  [[ ${lines[2]} =~ "tag" ]]
  [[ ${lines[3]} =~ "branch" ]]
  [[ ${lines[4]} =~ "date" ]]
}

@test "Statistics" {
  run bash -c 'echo ">stats >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
  [[ ${lines[1]} =~ "domains_being_blocked -1" ]]
  [[ ${lines[2]} =~ "dns_queries_today 7" ]]
  [[ ${lines[3]} =~ "ads_blocked_today 2" ]]
  [[ ${lines[4]} =~ "ads_percentage_today 28.571428" ]]
  [[ ${lines[5]} =~ "unique_domains 6" ]]
  [[ ${lines[6]} =~ "queries_forwarded 3" ]]
  [[ ${lines[7]} =~ "queries_cached 2" ]]
  [[ ${lines[8]} == "clients_ever_seen 3" ]]
  [[ ${lines[9]} == "unique_clients 3" ]]
  [[ ${lines[10]} == "status unknown" ]]
}

@test "Top Clients" {
  run bash -c 'echo ">top-clients >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
  [[ ${lines[1]} =~ "0 4 192.168.2.208" ]]
  [[ ${lines[2]} =~ "1 2 127.0.0.1" ]]
  [[ ${lines[3]} =~ "2 1 10.8.0.2" ]]
}

@test "Top Domains" {
  run bash -c 'echo ">top-domains >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
  [[ ${lines[1]} == "0 2 play.google.com" ]]
  [[ ${lines[2]} == "1 1 example.com" ]]
  [[ ${lines[3]} == "2 1 checkip.dyndns.org" ]]
  [[ ${lines[4]} == "3 1 raspberrypi" ]]
}

@test "Top Ads" {
  run bash -c 'echo ">top-ads >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
  [[ ${lines[1]} == "0 1 addomain.com" ]]
  [[ ${lines[2]} == "1 1 blacklisted.com" ]]
}

@test "Over Time" {
  run bash -c 'echo ">overTime >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
  [[ ${lines[1]} =~ "7 2" ]]
}

@test "Forward Destinations" {
  run bash -c 'echo ">forward-dest >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
  [[ ${lines[1]} =~ "0 57.14 ::1 local" ]]
  [[ ${lines[2]} =~ "1 14.29 2620:0:ccd::2 resolver2.ipv6-sandbox.opendns.com" ]]
  [[ ${lines[3]} =~ "2 9.52 2001:1608:10:25::9249:d69b" ]]
  [[ ${lines[4]} =~ "3 9.52 2001:1608:10:25::1c04:b12f" ]]
  [[ ${lines[5]} =~ "4 9.52 2620:0:ccc::2 resolver1.ipv6-sandbox.opendns.com" ]]
}

@test "Forward Destinations (unsorted)" {
  run bash -c 'echo ">forward-dest unsorted >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
  [[ ${lines[1]} =~ "0 9.52 2001:1608:10:25::9249:d69b" ]]
  [[ ${lines[2]} =~ "1 9.52 2001:1608:10:25::1c04:b12f" ]]
  [[ ${lines[3]} =~ "2 14.29 2620:0:ccd::2 resolver2.ipv6-sandbox.opendns.com" ]]
  [[ ${lines[4]} =~ "3 9.52 2620:0:ccc::2 resolver1.ipv6-sandbox.opendns.com" ]]
  [[ ${lines[5]} =~ "4 57.14 ::1 local" ]]
}

@test "Query Types" {
  run bash -c 'echo ">querytypes >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
  [[ ${lines[1]} == "A (IPv4): 71.43" ]]
  [[ ${lines[2]} == "AAAA (IPv6): 28.57" ]]
}

@test "Get all queries" {
  run bash -c 'echo ">getallqueries >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
  [[ ${lines[1]} =~ "IPv6 raspberrypi" ]]
  [[ ${lines[2]} =~ "IPv4 checkip.dyndns.org" ]]
  [[ ${lines[3]} =~ "IPv4 example.com" ]]
  [[ ${lines[4]} =~ "IPv4 play.google.com" ]]
  [[ ${lines[5]} =~ "IPv6 play.google.com" ]]
  [[ ${lines[6]} =~ "IPv4 blacklisted.com" ]]
  [[ ${lines[7]} =~ "IPv4 addomain.com" ]]
}

@test "Get all queries (domain filtered)" {
  run bash -c 'echo ">getallqueries-domain play.google.com >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
  [[ ${lines[1]} =~ "IPv4 play.google.com" ]]
  [[ ${lines[2]} =~ "IPv6 play.google.com" ]]
}

@test "Get all queries (domain + number filtered)" {
  run bash -c 'echo ">getallqueries-domain play.google.com (3) >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
  [[ ${lines[1]} =~ "IPv6 play.google.com" ]]
}

@test "Get all queries (client filtered)" {
  run bash -c 'echo ">getallqueries-client 127.0.0.1 >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
  [[ ${lines[1]} =~ "IPv6 raspberrypi" ]]
  [[ ${lines[2]} =~ "IPv4 checkip.dyndns.org" ]]
}

@test "Get all queries (client + number filtered)" {
  run bash -c 'echo ">getallqueries-client 127.0.0.1 (6) >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
  [[ ${lines[1]} =~ "IPv4 checkip.dyndns.org" ]]
}

@test "Memory" {
  run bash -c 'echo ">memory >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
  [[ ${lines[1]} =~ "memory allocated for internal data structure:" ]]
  [[ ${lines[2]} =~ "dynamically allocated allocated memory used for strings:" ]]
  [[ ${lines[3]} =~ "Sum:" ]]
}

@test "Recent blocked" {
  run bash -c 'echo ">recentBlocked >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
  [[ ${lines[1]} == "addomain.com" ]]
}

@test "DB test: Tables created and populated?" {
  run bash -c 'sqlite3 pihole-FTL.db .dump'
  echo "output: ${lines[@]}"
  [[ "${lines[@]}" == *"CREATE TABLE queries ( id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp INTEGER NOT NULL, type INTEGER NOT NULL, status INTEGER NOT NULL, domain TEXT NOT NULL, client TEXT NOT NULL, forward TEXT );"* ]]
  [[ "${lines[@]}" == *"CREATE TABLE ftl ( id INTEGER PRIMARY KEY NOT NULL, value BLOB NOT NULL );"* ]]
  [[ "${lines[@]}" == *"INSERT INTO \"ftl\" VALUES(0,1);"* ]]
}

@test "Arguments check: Invalid option" {
  run bash -c './pihole-FTL abc'
  echo "output: ${lines[@]}"
  [[ ${lines[0]} == "pihole-FTL: invalid option -- 'abc'" ]]
  [[ ${lines[1]} == "Try './pihole-FTL --help' for more information" ]]
}

@test "Help argument return help text" {
  run bash -c './pihole-FTL help'
  echo "output: ${lines[@]}"
  [[ ${lines[0]} == "pihole-FTL - The Pi-hole FTL engine" ]]
}

@test "Unix socket returning data" {
  run bash -c './socket-test travis'
  echo "output: ${lines[@]}"
  [[ ${lines[0]} == "Socket created" ]]
  [[ ${lines[1]} == "Connection established" ]]
  [[ ${lines[2]} == "domains_being_blocked -1" ]]
  [[ ${lines[3]} == "dns_queries_today 7" ]]
  [[ ${lines[4]} == "ads_blocked_today 2" ]]
  [[ ${lines[5]} == "ads_percentage_today 28.571428" ]]
  [[ ${lines[6]} == "unique_domains 6" ]]
  [[ ${lines[7]} == "queries_forwarded 3" ]]
  [[ ${lines[8]} == "queries_cached 2" ]]
  [[ ${lines[9]} == "clients_ever_seen 3" ]]
  [[ ${lines[10]} == "unique_clients 3" ]]
  [[ ${lines[11]} == "status unknown" ]]
}

@test "Final part of the tests: Killing pihole-FTL process" {
  run bash -c 'echo ">kill >quit" | nc -v 127.0.0.1 4711'
  echo "output: ${lines[@]}"
}
