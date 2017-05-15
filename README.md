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
I did the same steps with Krita and this was message after I ran the module:

```
Notice: Compiled catalog for spiderstorm.eqfgq4capfouriaj4cztiwndne.fx.internal.cloudapp.net in environment production in 0.21 seconds
Notice: /Stage[main]/Starvingartist/Package[krita]/ensure: ensure changed 'purged' to 'latest'
Notice: Finished catalog run in 84.25 seconds
```
I did these steps with every program and at this point my module looked like this: 
``` puppet
class starvingartist {
	
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
class starvingartist{
      
        $packages = [ 'fontforge', 'krita', 'gimp', 'inkscape','scribus']
        package { $packages:ensure => "latest",
                allowcdrom => "true",
        }
}

```

I tested this new module and it worked and I got that beautiful "Notice: Finished catalog run.." message. 

Now when everything worked fine I wanted to make sure my repositories are on order before installing any programs.
I'm not sure is this necessary when using type latest instead of the installed. But did not find straightforward answer for this from google so I did it anyway.

I found many diffrent options for building code that runs the command apt-get update. I ended up using instructions by John Leach. His instructions wore that use exec that that looks for the apt-get update command form usr/bin/ file and another Exec that ensures that no package can be installed before runing apt-get update. 


``` puppet
exec {'apt-get update':
                command  => ["/usr/bin/apt-get update"],
        }

        Exec["apt-get update"] -> Package <| |>

```
I run my module once again and it seemed to work.
Noitices that I got:

Notice: Compiled catalog for spiderstorm.eqfgq4capfouriaj4cztiwndne.fx.internal.cloudapp.net in environment production in 0.23 seconds
Notice: /Stage[main]/starvingartist/Exec[apt-get update]/returns: executed successfully
Notice: Finished catalog run in 7.95 seconds


## Sources:

### My blog post about this project
https://venlainkari.wordpress.com/2017/05/15/bulding-a-puppet-module-for-desingers/

### Installing modules, Puppet documentation:
https://docs.puppet.com/puppet/latest/modules_installing.html#install-from-the-$$m-the-puppet-forge

### Install multiple packages, Puppet cookbook:
https://www.puppetcookbook.com/posts/install-multiple-packages.html

### Exec type, Puppet documentation:
https://docs.puppet.com/puppet/latest/type.html#exec

### How to force apt-get update, Tim J. Robinson:
http://timjrobinson.com/puppet-how-to-force-apt-get-update/

### Puppet dependencies and run stages, John Leach:
http://johnleach.co.uk/words/771/puppet-dependencies-and-run-stages

### Course website, Tero Karvinen
http://terokarvinen.com/2017/aikataulu-%e2%80%93-linuxin-keskitetty-hallinta-%e2%80%93-ict4tn011-11-%e2%80%93-loppukevat-2017-p2

