class nrpe::base {
	$packagesList = [ 'nagios-plugins-standard', 'nagios-nrpe-server' ]
	$nrpe_allowed_hosts = extlookup('nrpe_allowed_hosts')
	$mysql_root_password = extlookup('mysql_root_password')

	service { 'nagios-nrpe-server':
		 provider => debian,
		 ensure => running,
		hasstatus => false,
		pattern => 'nrpe'
	}

	file { '/etc/nagios/nrpe_local.cfg':
		 notify => Service['nagios-nrpe-server'],
		 require => Package['nagios-nrpe-server'],
		 content => template('nrpe/nrpe-local.cfg.erb'),
		 owner => nagios,
		 group => nagios,
		 mode => 644
	}

	package { $packagesList:
		 ensure => installed
	}
}
