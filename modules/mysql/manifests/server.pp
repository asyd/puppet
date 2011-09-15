class mysql::server {
	include common::debian
	include nrpe::base

	$mysql_root_password = extlookup('mysql_root_password')
	
	common::debian::preseed_package { "mysql-server-5.1":
		ensure => present,
		source => 'mysql/mysql-preseed.erb'
	}

	file { '/etc/nagios/.my.cnf':
		require => [ Package['nagios-nrpe-server'], Package['mysql-server'] ],
		content => template('mysql/nrpe-mysql.erb'),
		notify => Service['nagios-nrpe-server'],
		owner => nagios,
		group => nagios,	
		mode => 400
	}
}
