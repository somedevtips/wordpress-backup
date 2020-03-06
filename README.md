# WordPress backup script
You can use this script to create a backup of your WordPress files and 
database.  It creates two files:  

* one .tar.bz2 or .tar.gz file containing the files
* one .sql file containing the dump of the database

## Requirements
You need access to the server console (typically through SSH)
and the WP-CLI installed.  
This script must be installed and run from the parent directory of the
WordPress installation (the parent directory of the wp-config.php file),
typically the parent directory of `public_html`.  
The backup files are created in the same directory of this script, so 
take care to install it in a non-public directory.

## Configuration
The script configuration is contained in the file sdtips-wpbackup-conf.txt.  
The parameters are:  
* WP_PATH: name of the directory containing the WordPress installation 
(default `public_html`)  
* ARCHIVE_EXTENSION: extension and compression algorithm to use for files, 
the possible values are `.tar.bz2` or `.tar.gz` (default `.tar.bz2`).  
* ARCHIVE_VERBOSE: set to 1 to make `tar` command verbose (default 0).

## Installation
1. Open the file sdtips-wpbackup-conf.txt and check the configuration
2. Upload the files sdtips-wpbackup-conf.txt and sdtips-wpbackup.sh to
the parent directory of the WordPress installation. **Please check that 
this is a non-public directory for security reasons.**   
3. Make the sh file executable:  
```bash
   chmod u+x sdtips-wpbackup.sh
```

## Execution
To create a backup you will execute the sdtips-wpbackup.sh script.  
This script has two parameters, the first is mandatory, the second one 
optional:  
1. what you want to backup between `full` (backup of all WordPress files), 
`system` (all files except wp-content), `wp-content` (only wp-content), 
`plugins` (only wp-content/plugins), `mu-plugins` (only wp-content/mu-plugins),
`themes` (only wp-content/themes).  
2. an optional comment (without spaces) that will be appended to the file 
names.

## Backup file names
The two backup files have the same name (but different extension):  
`backup_<type>_<date>_<hour>_<timezone>_<wp version>_<comment>`

## Example
For a full backup with comment 'after_installation' execute:  
```bash
 ./sdtips-wpbackup.sh full after_installation
```
