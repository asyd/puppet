class ntp::client {
	
	file { '/etc/ntp.conf':
		owner => root,
		group => root,
		mode => 644,
		content => template("ntp/ntp-client.conf.erb")
	}
}
