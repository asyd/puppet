class mysql::server {
	include common::debian
	include nagios::nrpe
	include smtp::postfix-base
	include backup::ninja

	$mysql_root_password = generate("/etc/puppet/scripts/makepasswd",extlookup("master_password"),$fqdn,"mysql")
	$mysql_nrpe_password = generate("/etc/puppet/scripts/makepasswd",extlookup("master_password"),$fqdn,"mysqlnrpe")

	define create-user($ensure = exist, $password, $host) {
		exec { "$name-$host":
			command => "/usr/bin/mysql -e \"GRANT SELECT ON mysql.* TO $name@'$host' IDENTIFIED BY '$password'\"",
			unless =>  "/usr/bin/mysql -e \"SELECT DISTINCT(user) FROM mysql.user WHERE host = '$host'\" | /bin/grep $name",
			require => File['/root/.my.cnf']
		}
	}

	create-user { "nagios":
		password => $mysql_nrpe_password,
		host => localhost
	}
	
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

	file { '/etc/backup.d/mysql.full':
		owner => root,
		group => root,
		mode => 400,
		source => "puppet:///mysql/backupninja-mysql.full",
		require => Class['backup::ninja']
	}
}
