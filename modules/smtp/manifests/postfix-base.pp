class smtp::postfix-base {
	include common::debian
	
	service { postfix:
		ensure => running
	}

	common::debian::preseed_package {postfix:
		ensure => present,
		source => 'smtp/postfix-base-preseed.erb',
		notify => Service['postfix']
	}
}
