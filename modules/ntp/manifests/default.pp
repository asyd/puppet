class ntp::default {
	$ntpServers = extlookup("ntp_servers")

	$requiredPackages = [
		"ntp"
	]

	package { $requiredPackages:
		ensure => installed
	}
	
	if ($ntp_mode == "server") {
		include ntp::server
	} else {
		include ntp::client
	}
}
