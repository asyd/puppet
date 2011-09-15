class ntp::server {
	
	file { '/etc/ntp.conf':
		owner => root,
		group => root,
		mode => 644,
		content => template("ntp/ntp-server.conf.erb")
	}
}
