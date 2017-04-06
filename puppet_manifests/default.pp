# Puppet Stages
stage {
    'users':       before => Stage['folders'];
    'folders':     before => Stage['updates'];
    'updates':     before => Stage['packages'];
    'packages':    before => Stage['apache'];
    'apache':      before => Stage['mysql'];
    'mysql':       before => Stage['php'];
    'php':         before => Stage['solr'];
    'solr':        before => Stage['services'];
    'services':    before => Stage['main'];
}

class users {
    group { "www-data":
        ensure => "present",
     }
}

class folders {
    file { ['/var/www']:
        ensure => 'directory',
        owner => 'www-data',
        group => 'www-data',
        mode => 0755
    }
}

class updates {
    exec {
        "add-php-repository":
            command => '/usr/bin/add-apt-repository -y ppa:ondrej/php',
            timeout => 0;
        "aptitude-update":
            command => "/usr/bin/aptitude update -y -q",
            timeout => 0;
    }
}

class packages {
    package {[
            "git",
            "ntp",
            "curl",
            "unzip",
            "apache2",
            "imagemagick",
            "sendmail",
            "memcached",
            "redis-server",
            "default-jre",
            "mysql-server",
            "build-essential",
            "libcurl3-openssl-dev",
            "php5",
            "php5-gd",
            "php5-cli",
            "php5-dev",
            "php5-apcu",
            "php5-curl",
            "php5-mysql",
            "php-mysql",
            "php5-mcrypt",
            "php5-memcache",
            "php5-redis",
            "php-pear",
            "tomcat6",
            ]:
        ensure => "present",
    }
    exec { 'Install WP CLI':
        command => "/usr/bin/curl -o /usr/bin/wp -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar",
        require => [ Package['curl'], Package['php5-cli'] ],
        creates => "/usr/bin/wp"
    }

    # Change the mode of WP-CLI to a+x
    file { '/usr/bin/wp':
        mode => "775",
        require => Exec['Install WP CLI']
    }
}

class apache {
    $location = "Cambridge"
    $country = "US"
    $state = "MA"
    $organization = "TAG"
    $unit = "Search"
    $commonname = "www.thirdandgrove.com"
    $keyname = "www_thirdandgrove_com"

    $subject = "/C=${country}/ST=${state}/L=${location}/O=${organization}/OU=${unit}/CN=${commonname}"
    exec {
        "clear-apache-conf":
            command => '/usr/bin/sudo rm /etc/apache2/sites-enabled/*default*',
            onlyif => '/bin/ls /etc/apache2/sites-enabled/000-default.conf';

        "copy-apache-conf":
            command => '/usr/bin/sudo cp /vagrant/wordpress-skeleton/vagrant/apache.conf /etc/apache2/sites-enabled/apache.conf';

        "copy-apache-ssl-conf":
            command => '/usr/bin/sudo cp /vagrant/wordpress-skeleton/vagrant/apache_ssl.conf /etc/apache2/sites-enabled/apache_ssl.conf';

        "apache-rewrite":
            command => '/usr/bin/sudo a2enmod rewrite';

        "apache-ssl-mod":
            command => '/usr/bin/sudo a2enmod ssl';

        "openssl-csr":
            command => "/usr/bin/openssl req -new -newkey rsa:2048 -x509 -days 365 -nodes -out ${keyname}.crt -keyout ${keyname}.key -subj \"${subject}\"",
            cwd => '/home/vagrant',
            creates => "/home/vagrant/${keyname}.key";
    }
}

class mysql {
    exec {
        "mysql-bind-address":
            command => '/usr/bin/sudo cp /vagrant/wordpress-skeleton/vagrant/bind.cnf /etc/mysql/conf.d/bind.cnf',
            unless => '/bin/ls /etc/mysql/conf.d/bind.cnf';

        "mysql-privilege":
            command => '/usr/bin/mysql -uroot -h 127.0.0.1 -e \'GRANT ALL PRIVILEGES ON *.* TO "vagrant"@"%" IDENTIFIED BY "vagrant"; FLUSH PRIVILEGES;\'';

        "mysql-create-database":
            command => '/usr/bin/mysql -uvagrant -pvagrant -h 127.0.0.1 -e \'CREATE DATABASE vagrant;\'',
            unless => '/usr/bin/mysql -uroot -h 127.0.0.1 vagrant';
    }
}

class php {
    exec {
        "enable-php-mcrypt":
            command => '/usr/bin/sudo php5enmod mcrypt';
        "php-apache2-apc":
            command => '/bin/echo "apc.rfc1867 = 1" >> /etc/php5/apache2/php.ini';
        "php-cli-apc":
            command => '/bin/echo "apc.rfc1867 = 1" >> /etc/php5/cli/php.ini';

        "memcached-bind-address":
            command => '/usr/bin/sudo cp /vagrant/wordpress-skeleton/vagrant/memcached.conf /etc/memcached.conf';
    }
}

class solr {
    exec {
        "download":
            command => '/usr/bin/wget http://archive.apache.org/dist/lucene/solr/3.5.0/apache-solr-3.5.0.tgz';
        "untar":
            command => '/bin/tar -zxvf apache-solr-3.5.0.tgz',
            require => Exec['download'];
        "locate":
            command => '/bin/mv apache-solr-3.5.0 /usr/share/solr',
            require => Exec['untar'];
        "config":
            command => '/bin/cp /vagrant/wordpress-skeleton/vagrant/solr.xml /etc/tomcat6/Catalina/localhost/',
            require => Exec['locate'];
        "own":
            command => '/bin/chown -R tomcat6 /usr/share/solr/example/solr',
            require => Exec['config'];
        "own_xml":
            command => '/bin/chown tomcat6 /etc/tomcat6/Catalina/localhost/solr.xml',
            require => Exec['own'];
    }
}

class services {
    exec {
        "redis-configure":
            command => "/usr/bin/sudo sed -i 's/bind 127.0.0.1/bind 0.0.0.0/g' /etc/redis/redis.conf";
        "apache-restart":
            command => '/usr/bin/sudo service apache2 restart';
        "memcached-restart":
            command => '/usr/bin/sudo /etc/init.d/memcached restart';
        "redis-restart":
            command => '/usr/bin/sudo /etc/init.d/redis-server restart';
        "mysql-restart":
            command => '/usr/bin/sudo service mysql restart';
        "tomcat-restart":
            command => '/usr/bin/sudo /etc/init.d/tomcat6 restart';
    }
}

class {
    users:       stage => "users";
    folders:     stage => "folders";
    updates:     stage => "updates";
    packages:    stage => "packages";
    apache:      stage => "apache";
    mysql:       stage => "mysql";
    php:         stage => "php";
    solr:        stage => "solr";
    services:    stage => "services";
}
