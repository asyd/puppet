class roles::base {
	include common::debian
	include common::fusion

	common::debian::key { B1CF47B7:
		source => "http://packages.nnx.com/nnx.key"
	}

	common::debian::repository { nnx:
		url => "http://packages.nnx.com/"
	}

	include puppet::base
	include ntp::default
	include smtp::postfix-base
	include nagios::nacup
}
