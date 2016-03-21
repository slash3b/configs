#! /bin/bash

if [[ $EUID -ne 0 ]]; then
   echo -e "\033[1;41mPlease run this script as sudo user\033[0m"
   exit 1
fi

file_location=$(pwd)/$(basename $0)
file_name=$(basename $0)
# on first run lets make symbolic link
exists=$(which deploy)
if [[ -z $exists ]]
  then
	  ln -s $file_location /usr/local/bin/${file_name%.*}
	  echo -e "\033[1;36m\nNext time instead of ./deploy.sh you can launch ${file_name%.*}\033[0m"
fi

deploy=0
provision=0
help=0
APACHE_LOG_DIR=/var/log/apache2

while getopts hdp opts
do
	case $opts in
		h | help)
		help=1
		;;
		d)
		deploy=1
		;;
		p)
		provision=1
		;;
		*)
		echo "Please check help by typing 'deploy -h.\n Basically there are two arguments -d or -p.\n"
		exit 0
		;;
	esac
done

if [[ $help -eq 1 ]]
	then
	printf "Just 'deploy -d' in the folder you wish to be deployed on your local server.\n"
	printf "Type 'deploy -p' if you wish to install basic setup which includes:\n"
	printf "\t-Apache\n"
	printf "\t-MySQL\n"
	printf "\t-PHP 5.5.9\n"
	printf "\t-Xdebug\n"
	printf "\t-Java 8\n"
	printf "\t-Fish\n"
	printf "\t-Tmux\n"
fi

if [[ $deploy -eq 1 ]]
	then
	printf "Start...\n"
	# project_name=$(echo "$(pwd)" | sed 's/[a-z]*\///ig')
	# better way to find current folder name
	pwd=$(pwd)
	project_name=${pwd##*/}
	echo "127.0.0.1       $project_name.local"  >> /etc/hosts

	conf="/etc/apache2/sites-available/$project_name.conf"
	
	echo '<VirtualHost *:80>'  > $conf
	echo "  ServerAdmin admin@example.com"  >> $conf
	echo "  ServerName $project_name.local"  >> $conf
	echo "  ServerAlias www.$project_name.local"  >> $conf
	echo "  DocumentRoot /var/www/html/$project_name"  >> $conf
	echo "  <Directory /var/www/html/$project_name>"  >> $conf
	echo "    Options Indexes FollowSymLinks MultiViews"  >> $conf
	echo "    AllowOverride All"  >> $conf
	echo "    Order allow,deny"  >> $conf
	echo "    allow from all"  >> $conf
	echo "  </Directory>"  >> $conf
	echo "  ErrorLog $APACHE_LOG_DIR/${project_name}_error.log"  >> $conf
	echo "  CustomLog $APACHE_LOG_DIR/${project_name}_access.log combined"  >> $conf
	echo '</VirtualHost>'  >> $conf
	a2ensite $project_name".conf"
	service apache2 restart
  service apache2 status
	printf "\nYour site is running: $project_name.local\n"
fi

if [[ $provision -eq 1 ]]
  then
    apt-get update;
    apt-get install apache2 -y;
    a2enmod rewrite;
    printf "Would you like to install PHP7 (y/n)? \nIf NO then php 5.5 will be installed."
    read answer
    if echo "$answer" | grep -iq "^y" ;then
      printf "Hooooray, let break some staff! \n Installing PHP7 ... \n"
      add-apt-repository ppa:ondrej/php-7.0 -y;
      apt-get update -y;
      apt-get install php7.0 -y;
      apt-get install php7.0-mysql -y;
      apt-get install php-xdebug -y;
      apt-get install php7.0-gd -y;
      apt-get install php7.0-curl -y;
      echo '[xdebug]'  >> /etc/php/7.0/apache2/php.ini
      echo 'zend_extension="/usr/lib/php/20151012/xdebug.so"' >> /etc/php/7.0/apache2/php.ini
      echo 'xdebug.remote_enable=1' >> /etc/php/7.0/apache2/php.ini
      echo 'xdebug.remote_handler=dbgp' >> /etc/php/7.0/apache2/php.ini
      echo 'xdebug.remote_mode=req' >> /etc/php/7.0/apache2/php.ini
      echo 'xdebug.remote_host=127.0.0.1' >> /etc/php/7.0/apache2/php.ini
      echo 'xdebug.remote_port=9000' >> /etc/php/7.0/apache2/php.ini
      echo 'xdebug.max_nesting_level=300' >> /etc/php/7.0/apache2/php.ini
      echo 'xdebug.var_display_max_depth=150' >> /etc/php/7.0/apache2/php.ini
    else
      printf "Installing PHP5 ... \n"
      # do not forget to 'RewriteEngine on' in .htaccess
      #  chmod 644 .../.htaccess
      apt-get install mysql-server php5-mysql;
      apt-get install php5 libapache2-mod-php5 php5-mcrypt php5-gd;
      # rewrite content of the following file
      #  nano /etc/apache2/mods-enabled/dir.conf
      apt-get install php5-cli;
      apt-get install php5-xdebug -y;
      # add xdebug  config
      echo '# Added for xdebug' >> /etc/php5/apache2/php.ini
      echo "zend_extension=\"/usr/lib/php5/20100525/xdebug.so\"" >> /etc/php5/apache2/php.ini
      echo 'xdebug.remote_enable=1' >> /etc/php5/apache2/php.ini
      echo 'xdebug.remote_handler=dbgp ' >> /etc/php5/apache2/php.ini
      echo 'xdebug.remote_mode=req' >> /etc/php5/apache2/php.ini
      echo 'xdebug.remote_host=127.0.0.1 ' >> /etc/php5/apache2/php.ini
      echo 'xdebug.remote_port=9000' >> /etc/php5/apache2/php.ini
    fi

    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list;
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list;
    mysql_install_db;
    mysql_secure_installation;
    service apache2 restart;
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886;
    apt-get install oracle-java8-installer -y;
    apt-get install tmux -y;
    apt-get install fish -y; set fish_greeting ""
    apt-get install git -y;
    git config --global core.excludesfile '~/.gitignore';
    echo '.idea' >> ~/.gitignore
fi
