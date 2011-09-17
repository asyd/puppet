class common::debian {

        file { "/var/local/preseed":
                ensure => directory,
                mode => 700,
                owner => root,
                group => root
        }

	exec { "apt-update":
		command => "/usr/bin/aptitude update",
		refreshonly => true,
		returns => [ 0, 255 ]
	}

	define key ($ensure = present, $source) {
		exec { "$name":
			command => "/usr/bin/wget $source -O - | apt-key add -",
			unless => "/usr/bin/apt-key list | grep $name",
			notify => Exec['apt-update']
		} 
	}

	define repository ($ensure = present, $url) {
		file { "/etc/apt/sources.list.d/$name.list":
			content => template("common/apt-repository.erb"),
			notify => Exec['apt-update']
		}
	}

	define preseed_package ($ensure, $source) {
		file { "/var/local/preseed/$name.preseed":
			ensure => present,
			require => File['/var/local/preseed'],
			content => template($source),
			owner => root,
			group => root,
			mode => 400
		}

		package { "$name":
			ensure => installed,
			require => File["/var/local/preseed/$name.preseed"],
			responsefile => "/var/local/preseed/$name.preseed"
		}
	}

}
