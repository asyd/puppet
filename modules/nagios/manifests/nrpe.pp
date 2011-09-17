class nagios::nrpe {
	$packagesList = [ 'nagios-plugins-standard', 'nagios-nrpe-server' ]
	$nrpe_allowed_hosts = extlookup('nrpe_allowed_hosts')

	service { 'nagios-nrpe-server':
		provider => debian,
		ensure => running,
		hasstatus => false,
		pattern => 'nrpe'
	}

	file { '/etc/nagios/nrpe_local.cfg':
		 notify => Service['nagios-nrpe-server'],
		 require => Package['nagios-nrpe-server'],
		 content => template('nagios/nrpe-local.cfg.erb'),
		 owner => nagios,
		 group => nagios,
		 mode => 644
	}

	package { $packagesList:
		 ensure => installed
	}
}
