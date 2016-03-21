## Deploy
Simple script to deploy web app on LAMP, in addition you may install all necessary
software on your local machine to get started right now.

Software provision (`deploy -p`) will install the following list of software:

    - apache2
    - enable mod rewrite for clean URLs (todo: enable 'RewriteEngine on' in .htaccess in case of deploy)
    - php5.6 or php7
    - xdebug
    - mySQL Ver 14.14 Distrib 5.5.46
    - php driver for mySQL
    - Java 8.0
    - tmux
    - fish v.2.0.0
    - GIT v1.9.1
