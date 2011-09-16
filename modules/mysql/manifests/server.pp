class mysql::server {
	include common::debian
	include nrpe::base

#	$mysql_root_password = extlookup('mysql_root_password')
#	$mysql_root_password = generate('/etc/puppet/scripts/makepasswd')
	$mysql_nrpe_password = extlookup('mysql_nrpe_password')
	
	common::debian::preseed_package { "mysql-server-5.1":
		ensure => present,
		source => 'mysql/mysql-preseed.erb',
	}

	exec { notify-password:
		command => "/bin/echo \"MySQL root password on $fqdn: $mysql_root_password\" | mail -s 'MySQL root password' bbonfils@gmail.com",
		refreshonly => true
	}

	file { '/etc/nagios/.my.cnf':
		require => Class['common::debian'],
		content => template('mysql/nrpe-mysql.erb'),
		notify => Service['nagios-nrpe-server'],
		owner => nagios,
		group => nagios,	
		mode => 400
	}
	
	file { '/root/.my.cnf':
		owner => root,
		group => root,
		mode => 400,
		content => template('mysql/root-my-cnf.erb'),
		notify => Exec['notify-password']
	}
}
