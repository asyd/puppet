class common::fusion {
	$packages = [ 'fusioninventory-agent', 'pciutils', 'smartmontools' ]

	package { $packages:
		ensure => installed
	}

}
