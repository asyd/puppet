class puppet::base {

	$minutes = generate("/etc/puppet/scripts/random-number", "minute", $fqdn)

	file { '/etc/puppet/puppet.conf':
		ensure => present,
		mode => 644,
		owner => root,
		group => root,
		source => "puppet:///modules/puppet/puppet.conf"
	}

	cron { "puppet":
	        ensure  => $puppet_interval ? {
			'none' => absent,
			default => present
		},
	        command => "/usr/sbin/puppetd --onetime --no-daemonize --logdest syslog > /dev/null 2>&1",
	        user    => 'root',
	        minute  => $minutes,
		hour => $puppet_interval ? {
			'daily' => generate("/etc/puppet/scripts/random-number", "hour", $fqdn),
			default => undef
		}
	}
}
