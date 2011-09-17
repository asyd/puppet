class mysql::server {
	include common::debian
	include nrpe::base
	include smtp::postfix-base

	$mysql_root_password = generate("/etc/puppet/scripts/makepasswd",$fqdn,"mysql")
	$mysql_nrpe_password = extlookup('mysql_nrpe_password')
	
	common::debian::preseed_package { "mysql-server-5.1":
		ensure => present,
		source => 'mysql/mysql-preseed.erb',
	}

	exec { notify-password:
		command => "/bin/echo \"MySQL root password on $fqdn: $mysql_root_password\" | mail -s 'puppet password' support@nnx.com",
		refreshonly => true,
		require => Class['smtp::postfix-base']
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

	file { '/etc/nagios/nrpe.d/mysql':
		owner => root,
		group => root,
		mode => 644,
		content => "command[check_mysql]=env HOME=/etc/nagios /usr/lib/nagios/plugins/check_mysql"
	}
}
