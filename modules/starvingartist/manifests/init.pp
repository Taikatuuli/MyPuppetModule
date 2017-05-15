class starvingartist {

	exec {'apt-get update':
                command  => ["/usr/bin/apt-get update"],
        }

        Exec["apt-get update"] -> Package <| |>

	$packages = [ 'fontforge', 'krita', 'gimp', 'inkscape','scribus']
        package { $packages:ensure => "latest",
                allowcdrom => "true",
        }
}
