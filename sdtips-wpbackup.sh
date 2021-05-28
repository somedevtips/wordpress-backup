#!/bin/bash

. sdtips-wpbackup-conf.txt

if [ -z $WP_PATH ]; then
  echo "Configuration file missing. Impossible to continue."
  exit
fi

WP_VERSION=`wp core version --path=$WP_PATH`
if [ -z $WP_VERSION ]; then
  echo "WP version not found. Impossible to continue."
  exit
fi

if [ -z $1 ]; then
  echo "Please enter backup type: full, nouploads, system, wp-content, plugins, themes, mu-plugins"
  exit
fi

EXCLUDE=''
if [ "$1" == "full" ]; then
  DIR_TO_BACKUP=$WP_PATH
elif [ "$1" == "nouploads" ]; then
  DIR_TO_BACKUP=$WP_PATH
  EXCLUDE="--exclude=${WP_PATH}/wp-content/uploads"
elif [ "$1" == "system" ]; then
  DIR_TO_BACKUP=$WP_PATH
  EXCLUDE="--exclude=${WP_PATH}/wp-content"
elif [ "$1" == "wp-content" ]; then
  DIR_TO_BACKUP=$WP_PATH/wp-content
elif [ "$1" == "plugins" ]; then
  DIR_TO_BACKUP=$WP_PATH/wp-content/plugins
elif [ "$1" == "mu-plugins" ]; then
  DIR_TO_BACKUP=$WP_PATH/wp-content/mu-plugins
elif [ "$1" == "themes" ]; then
  DIR_TO_BACKUP=$WP_PATH/wp-content/themes
else
  echo "Wrong backup type: it can be full, nouploads, system, wp-content, plugins, themes, mu-plugins"
  exit
fi


#%z is the numeric timezone (es. +0100)
FILE_NAME=backup_$1_$(date +%Y_%m_%d_H%H_%M_%z)_$WP_VERSION

#Create file name
if [ -n "$2" ]; then
  FILE_NAME=$FILE_NAME"_"$2
fi
BACKUP_FILE_NAME=$FILE_NAME$ARCHIVE_EXTENSION

#Create backup
if [ "$ARCHIVE_EXTENSION" == ".tar.bz2" ]; then
  SWITCH_COMPR="j"
elif [ "$ARCHIVE_EXTENSION" == ".tar.gz" ]; then
  SWITCH_COMPR="z"
else
  echo "Parameter ARCHIVE_EXTENSION in configuration file wrong"
  exit
fi

if [ "$ARCHIVE_VERBOSE" == 1 ]; then
  SWITCH_VERB="v"
else
  SWITCH_VERB=""
fi

echo "Creating backup of files: $BACKUP_FILE_NAME"
tar $EXCLUDE -c${SWITCH_COMPR}${SWITCH_VERB}f $BACKUP_FILE_NAME $DIR_TO_BACKUP 

echo "Database dump"
wp db export --path=$WP_PATH ${FILE_NAME}.sql

echo "Backup files created with success"
