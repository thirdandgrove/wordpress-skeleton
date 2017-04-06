<?php
/**
 * Local configuration file to add local database to dev environment.
 * To use this file, make a copy and place it in Wordpress root.
 *
 * Place this as the first PHP line in the file.
 *

  if ( dirname(__FILE__) . '/wordpress-skeleton/wp-goodies/wp-config-local.php' )
    require_once( dirname(__FILE__) . '/wordpress-skeleton/wp-goodies/wp-config-local.php' );

 *
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'vagrant');

/** MySQL database username */
define('DB_USER', 'vagrant');

/** MySQL database password */
define('DB_PASSWORD', 'vagrant');

/** MySQL hostname */
define('DB_HOST', 'localhost');

define('WP_DEBUG', true);
