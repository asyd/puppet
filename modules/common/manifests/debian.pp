class common::debian {

        file { "/var/local/preseed":
                ensure => directory,
                mode => 700,
                owner => root,
                group => root
        }

	define preseed_package ($ensure, $source) {
		file { '/var/local/preseed/$name.preseed':
			ensure => present,
			require => File['/var/local/preseed'],
			content => template($source)
		}

		package { $name:
			ensure => installed,
			require => File['/var/local/preseed/$name.preseed'],
			responsefile => '/var/local/preseed/$name.preseed'
		}
	}
}
