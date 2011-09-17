class nagios::nacup {
	include nagios::nrpe

	$packages = [ "nacup" ]

	package { $packages:
		ensure => installed
	}

	file { "/etc/nagios/nrpe.d/nacup":
		content => "command[check_apt-nacup]=/usr/bin/nacup",
		require => Class['nagios::nrpe']
	}
}
