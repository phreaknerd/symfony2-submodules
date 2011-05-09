#!/bin/sh
DIR=`php -r "echo dirname(realpath('$0'));"`
DIR="$DIR/symfony-standard"
VENDOR="$DIR/vendor"
BUNDLES="$VENDOR/bundles"

git clone https://github.com/symfony/symfony-standard.git

cd $DIR
rm -Rf ".git"
rm ".gitignore"

git init
git add .
git commit -m "initial import"

mkdir -p vendor

install_git()
{
    INSTALL_DIR=$1
    SOURCE_URL=$2
    REV=$3

    echo "> Installing/Updating submodule" $INSTALL_DIR

    if [ -z $REV ]; then
        REV=origin/HEAD
    fi

    if [ ! -d $INSTALL_DIR ]; then
        git submodule add $SOURCE_URL $INSTALL_DIR
    fi

    cd $INSTALL_DIR
    git fetch origin
    git reset --hard $REV
    cd $DIR
}

# Assetic
install_git vendor/assetic http://github.com/kriswallsmith/assetic.git

# Symfony
install_git vendor/symfony http://github.com/symfony/symfony.git

# Doctrine ORM
install_git vendor/doctrine http://github.com/doctrine/doctrine2.git 2.0.4

# Doctrine DBAL
install_git vendor/doctrine-dbal http://github.com/doctrine/dbal.git 2.0.4

# Doctrine Common
install_git vendor/doctrine-common http://github.com/doctrine/common.git 2.0.2

# Swiftmailer
install_git vendor/swiftmailer http://github.com/swiftmailer/swiftmailer.git origin/4.1

# Twig
install_git vendor/twig http://github.com/fabpot/Twig.git

# Twig Extensions
install_git vendor/twig-extensions http://github.com/fabpot/Twig-extensions.git

# Monolog
install_git vendor/monolog http://github.com/Seldaek/monolog.git

# SensioFrameworkExtraBundle
mkdir -p vendor/bundles/Sensio/Bundle
install_git vendor/bundles/Sensio/Bundle/FrameworkExtraBundle http://github.com/sensio/SensioFrameworkExtraBundle.git

# SecurityExtraBundle
mkdir -p vendor/bundles/JMS
install_git vendor/bundles/JMS/SecurityExtraBundle http://github.com/schmittjoh/SecurityExtraBundle.git

# Symfony bundles
mkdir -p vendor/bundles/Symfony/Bundle

# WebConfiguratorBundle
install_git vendor/bundles/Symfony/Bundle/WebConfiguratorBundle http://github.com/symfony/WebConfiguratorBundle.git

# Update the bootstrap files
$DIR/bin/build_bootstrap.php

# Update assets
$DIR/app/console assets:install $DIR/web/

#make log and cache writable
chmod -R 0777 app/logs
chmod -R 0777 app/cache

git add .
git commit -m "install submodules and web-assets"

echo "done. Now open web/config.php to start the config. http://localhost/config.php"
