#!/bin/bash

LIST=$(psql -l | awk '{ print $1 }' | grep '^[a-z]' | grep -v template | grep -v postgres | grep -v List | grep -v Name)
for DB in $LIST
do
        DATETODAY=$(date +"%Y%m%d")
        BACKUPFILE=$DEST_FOLDER/$DATETODAY.$DB.dmp
        echo -e "\n"
        echo $(date +"%Y%m%d %H%M%S")
        echo "Backing up $DB to $BACKUPFILE"
        pg_dump --host $PGHOST --port $PGPORT --username $PGUSER -Fc -v -f$BACKUPFILE ${DB}
        echo "$DB backup complete"
done
echo -e "\n"
echo $(date +"%Y%m%d %H%M%S")
echo "Backing up globals"
pg_dumpall --host $PGHOST --port $PGPORT --username $PGUSER --globals-only > $DEST_FOLDER/$DATETODAY.globals.sql
echo "globals backup complete"

WEEKDAY=`date "+%u"` #1-7, 1 is monday
MONTHDAY=`date "+%d"` #01-31 day of month

if [ $MONTHDAY -eq 01 ]; then
  LAPSE="monthly"
elif [ $WEEKDAY -eq 7 ]
then
  LAPSE="weekly"
else
  LAPSE="daily"
fi

echo "running "$LAPSE" backup"

/usr/bin/aws s3 mv $DEST_FOLDER/ s3://$AWS_BUCKET/$LAPSE/$CUR_HOSTNAME/postgresql/ --recursive