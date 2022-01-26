# Keeping your platform bloat free and up to date

For linux it may be useful to keep your apps and distro up to date. Below I'll go over what can be done and how it can be automated if you want.

## Ubuntu Maintenance Task using Command Line

Some of the basic maintenance tasks that should be performed is upgrading and cleaning of old files. You can use the below commands via your SSH login, if applicable to run and perform maintenance of your ubuntu instance.

### Update the apt repository below:

``` sudo apt-get update ```

### Upgrade the Ubuntu server distribution using the below command:

``` sudo apt-get dist-upgrade -y ```

### Upgrade the entire Ubuntu server with the below command:

``` sudo apt-get upgrade -y ```

### Remove older Ubuntu upgraded system files using the below command:

``` sudo apt-get autoremove ```

### Clean obsolete Ubuntu server files:

``` sudo apt-get autoclean ```

### Reboot the server:

``` reboot ``` or ``` sudo reboot ``` if needed

## Automating Ubuntu Maintenance using CRONTAB

Doing these commands manually are not ideal and as such can be automated using CRONTAB which can run tasks on a schedule.

We will setup a rule that will tell the server to execute a pre-defined set of commands that can update, upgrade, clean and remove old files.

### To edit your crontab file use the below command:

``` sudo nano /etc/crontab ```

Insert the below code after the existing rules and this will set the task to run daily at a time you choose, I would suggest setting it at a time where your Livepeer streams are usually at a low to avoid competing for resources.

``` 00 10 * * * root sudo sh -c 'apt-get update; apt-get upgrade -y; apt-get dist-upgrade -y; apt-get autoremove -y; apt-get autoclean -y' ```

This will run the command every day at 10 AM every day, see below for the example placement of time. If you want to change the frequency, change the corresponding * to what time you would like, for example 10 AM once a month on the first would look like ``` 00 10 1 * * <your command here> ```

```
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
```