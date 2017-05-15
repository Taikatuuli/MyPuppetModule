class starvingartist {

	exec {'apt-get update':
		path => ["/usr/bin"],
		require => Exec ["apt-get update"],
	}
	
	package{'krita':
		ensure => "latest",	
		allowcdrom => "true",
	}
	
	package{'inkscape':
		ensure => "latest",
		allowcdrom => "true",
	}	


	package{'fontforge':
		ensure => "latest",
		allowcdrom = "true",
	}

	package{'scribus':
                ensure => "latest",
                allowcdrom => "true",
        }

        package{'gimp':
                ensure => "latest",
                allowcdrom => "true",
	 }
}
