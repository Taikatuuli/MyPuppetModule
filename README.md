# MyPuppetModule

I started bulding my pyppet code by adding one packge that installs one of the programs and testing it after that. 
First I tried installing program called FontForge.
My code looked like this:

```puppet 
class starvingartist{

	package{'fontforge':
		ensure => "latest",
		allowcdrom = "true",
	}
}
```
I ran the Puppet module and tested did FontForge actually got installed by runing command fontforge.
Command gave me information about the program and an message: Could not open screen. This is because I'm working on a ssh session to my ubuntu server via PuTTY.  
```
Taikatuuli@SPIDERSTORM:~/MyPuppetModule/modules/starvingartist/manifests$ fontforge

Copyright (c) 2000-2012 by George Williams.
 Executable based on sources from 14:57 GMT 31-Jul-2012-ML.
 Library based on sources from 14:57 GMT 31-Jul-2012.
Could not open screen.
```
Fontforge oli siis asentunut, mutta ei suotstu aukeamaan sillä käytän palvelinta PuTTY:n kautta. 

Kokeillaan Kritan asentamista samalla tapaa kuin frontorge:

```
Notice: Compiled catalog for spiderstorm.eqfgq4capfouriaj4cztiwndne.fx.internal.cloudapp.net in environment production in 0.21 seconds
Notice: /Stage[main]/Art/Package[krita]/ensure: ensure changed 'purged' to 'latest'
Notice: Finished catalog run in 84.25 seconds
```
Lisäsin testaten jokaista asennusta uuden package:n.
Kaikki sujui ja asentu ongelmitta.

Lisäsin modulliin :

``` puppet
 exec {'apt-get update':
                path => ["/usr/bin"],
                require => Exec ["apt-get update"],
        }
    ```
Answer: 

```
Notice: Compiled catalog for spiderstorm.eqfgq4capfouriaj4cztiwndne.fx.internal.cloudapp.net in environment production in 0.23 seconds
Error: Failed to apply catalog: Found 1 dependency cycle:
(Exec[apt-get update] => Exec[apt-get update])
Try the '--graph' option and opening the resulting '.dot' file in OmniGraffle or GraphViz
``` 


At this point my module looked like this: 
``` puppet
class starvingartist {

	exec {'apt-get update':
		command => ["/usr/bin/apt-get update"],
		refreshonly => "true",
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
```
But I wanted the code work with only one packge so it would have less repetition and it would be easier to read. 
I made a variable packages and listed the programs in an array, so when I call the variable packages it will work like the pervious code. 

Now the code looked like this: 

``` puppet
class art{
        exec {'apt-get update':
                command  => ["/usr/bin/apt-get update"],
                refreshonly => true,
        }
        $packages = [ 'fontforge', 'krita', 'gimp', 'inkscape','scribus']
        package { $packages:ensure => "latest",
                allowcdrom => "true",
        }
}

```

I tested this new module and it worked and I got that beautiful "Notice: Finished catalog run.." message. 

sudo puppet apply --modulepath /home/Taikatuuli/Puppet/modules/ -e 'class {"art":}'


## Sources:

### Installing modules, Puppet documentation:
https://docs.puppet.com/puppet/latest/modules_installing.html#install-from-the-$$m-the-puppet-forge

### Install multiple packages, Puppet cookbook:
https://www.puppetcookbook.com/posts/install-multiple-packages.html

### Exec type: Puppet documentation:
https://docs.puppet.com/puppet/latest/type.html#exec

### How to force apt-get update: Tim J. Robinson:
http://timjrobinson.com/puppet-how-to-force-apt-get-update/
