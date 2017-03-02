# List of packages to support

## High priority installation

artemis http://www.sanger.ac.uk/resources/software/artemis/#download
MACS  https://github.com/taoliu/MACS
VEP http://www.ensembl.org/info/docs/tools/vep/index.html
Gemini http://gemini.readthedocs.org/en/latest/content/installation.html#automated-installation

## Make "stdenv" like file

Make StdEnv.lua like file for specific categofies e.g

- chipseq
- utils
- cnv
 
## Questions?

- need to understand ports. Why TCP 3838 for ShinyApps and not HTTP/HTTPS ?
- also nestat -tuple showed port 3838 before I enabled it?

## Nginx 

- [nice installation guied](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-16-04)
- `/var/www/html` - default location for file serving

#### Improtant nginx files

- `/etc/nginx/nginx.conf` - The main Nginx configuration file. This can be modified to make changes to the Nginx global configuraiton.
- `/etc/nginx/sites-available` - The directory where per-site "server blocks" can be stored. Nginx will not use the configuration files found in this directory unless they are linked to the sites-enabled directory (see below). Typically, all server block configuration is done in this directory, and then enabled by linking to the other directory.
- `/etc/nginx/sites-enabled/` - The directory where enabled per-site "server blocks" are stored. Typically, these are created by linking to configuration files found in the sites-available directory

## Brief modules writing guide

use the same case as how you would run the tool on the command line e.g snpEff as a module name because you'd run snpEff on the command line
e.g SPAdes module should actually be called, spades, because this is how you'd run it on the commnand line. Also there shouldn't be any "v" prefixes in the module names

