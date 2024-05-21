# Table of Contents
* [Docker PG Backup](#docker-pg-backup)
   * [Getting the image](#getting-the-image)
   * [Running the image](#running-the-image)
   * [Specifying environment variables](#specifying-environment-variables)
* [Credits](#credits)

# Docker PG Backup

A simple docker container that runs PostgreSQL backups.

This image has **NO DEFAULTS** and expects the user to fill in **ALL** environment variables.

It's behaviour is set to create a backup off all databases in a PostgreSQL instance, creating one file per database, with custom format (option '-Fc' for pg_dump).
Also creates a backup of the globals.

Each filename will have the format YYYYMMDD.DB_NAME.dmp (example: 20240520.db_name.dmp)

The backups are then uploaded to an S3 backend using AWS cli. Depending on  the day of the backup, it will be uploaded to a different folder on the S3 bucket (on this order):
- On day 1 of each month, it will be uploaded to "monthly" folder
- On sundays, it will be uploaded to "weekly" folder
- any other day will be uploaded to "daily" folder

Backups will be stored in s3://$AWS_BUCKET/$LAPSE/$CUR_HOSTNAME/postgresql/ (where LAPSE is "monthly", "weekly" or "daily")

* Visit our page on the docker hub at: [https://hub.docker.com/r/irradiare/irradiare-pg-backups](https://hub.docker.com/r/irradiare/irradiare-pg-backups)
* Visit our page on GitHub at: https://github.com/irradiare/irradiare-pg-backups


## Getting the image


```
docker pull irradiare/irradiare-pg-backups:latest
```


To build the image yourself do:

```
git clone https://github.com/irradiare/irradiare-pg-backups.git
cd irradiare-pg-backups
docker build -t irradiare-pg-backup . # this will build the image with the tag `irradiare-pg-backup`
```

## Running the image

The best way to run the container is to setup *ALL* environment variables on docker compose and run with:

```
docker compose up
```

## Specifying environment variables

* `CRON_SCHEDULE` in CRON format, for example "45 3 * * *" to make the backup at 3h45 am every day
* `DEST_FOLDER` the folder to which the backup should be done. Useful if you want to mount a volume to the container
* `PGPASSWORD` the password for the postgres user
* `PGPORT` the port for the postgres instance
* `PGUSER` the user for the postgres instance
* `PGHOST` the hostname for the postgres instance
* `CUR_HOSTNAME` the hostname of the machine running the container (can be obtained from machine itself, deopending on the shell and OS, but this allows for finer tweaking in case we want to move the backups container to another machine)
* `AWS_BUCKET` the name of the S3 bucket to which the backups will be uploaded
* `AWS_ACCESS_KEY_ID` the AWS access key id
* `AWS_SECRET_ACCESS_KEY` the AWS secret access key
* `AWS_REGION` the AWS region


**Note** To avoid interpolation issues with the env variable `${CRON_SCHEDULE}` you will need to provide the variable as a quoted string i.e ```${CRON_SCHEDULE}='*/1 * * * *'``` or ```${CRON_SCHEDULE}="*/1 * * * *"```

Here is a docker-compose.yml example for [docker composer](https://github.com/irradiare/irradiare-pg-backups/blob/master/docker-compose.yml):


# Credits

This work is based on the work of [kartoza/docker-pg-backup](https://github.com/kartoza/docker-pg-backup/) which provides a much broader set of options for PostgreSQL backups.