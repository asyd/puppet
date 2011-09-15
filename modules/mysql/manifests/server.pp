class mysql::server {
	include common::debian

	$packagesList = [ 'nagios-plugins-standard', 'nagios-nrpe-server', 'debconf-utils' ]

	$nrpe_allowed_hosts = extlookup('nrpe_allowed_hosts')
	$mysql_root_password = extlookup('mysql_root_password')
	
	common::debian::preseed_package { "mysql-server-5.1":
		ensure => present,
		source => 'mysql/mysql-preseed.erb'
	}

	package { $packagesList:
		ensure => installed
	}

#	service { 'nagios-nrpe-server':
#		provider => debian,
#		ensure => running
#	}
#
#	file { '/etc/nagios/.my.cnf':
#		require => [ Package['nagios-nrpe-server'], Package['mysql-server'] ],
#		content => template('mysql/nrpe-mysql.erb'),
#		notify => Service['nagios-nrpe-server'],
#		owner => nagios,
#		group => nagios,	
#		mode => 400
#	}
#	
#	file { '/etc/nagios/nrpe_local.cfg':
#		notify => Service['nagios-nrpe-server'],
#		require => Package['nagios-nrpe-server'],
#		content => template('mysql/nrpe-local.cfg.erb'),
#		owner => nagios,
#		group => nagios,
#		mode => 644
#	}
}
