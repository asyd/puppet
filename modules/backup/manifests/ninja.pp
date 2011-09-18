class backup::ninja {
	$packages = [ 'backupninja' ]

	package { $packages:
		ensure => installed
	}
}
