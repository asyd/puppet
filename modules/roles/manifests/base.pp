class roles::base {
	include puppet::base
	include ntp::default
	include smtp::postfix-base
}
