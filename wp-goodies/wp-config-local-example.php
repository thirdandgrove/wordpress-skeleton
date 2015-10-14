<?php
/**
 * Local configuration file to add local database to dev environment.
 * To use this file, make a copy and place it in Wordpress root.
 *
 * if (file_exists(dirname(__FILE__) . '/wordpress-skeleton/wp-goodies/wp-config-local.php') {
 *  require_once(dirname(__FILE__) . '/wordpress-skeleton/wp-goodies/wp-config-local.php');
 * }
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

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');
