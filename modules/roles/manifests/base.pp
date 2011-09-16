class roles::base {
	include ntp::default
	include smtp::postfix-base
}
