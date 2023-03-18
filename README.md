# Overview #

There may be times when you want to schedule a periodic task in a docker container (for example in one of the projects we wanted to periodically fetch weather data). An easy appraoch to realize this is to use a **cron-file**. This is is a dummy project that shows how cron can be used to periodically write to a file.

The thing to know about cron, is that it knows nothing about your shell; it is started by the system, so it has a minimal environment. If you want anything, you need to have that brought in yourself. This means:
- Full paths will be required to launch programs. `python` will not work -> it will need to be `/usr/bin/env python`
- Any environemntal variables you want to use will need to be placed in the `/etc/environment` file, as they are loaded by cron.

> Note that the script will be run every minute e.g. 12:23:00, so you might need to wait before getting a result

## Cron-file ##
See [this article](https://www.computerhope.com/unix/ucrontab.htm) that explains the basis of what needs to be in a cron-file and the significance of `* * * * *`.

``` text
# Write a dummy log every minute
* * * * *  cd /core && echo "🍄" >> /var/log/cron.log 2>&1

# Run python script every 10 minutes
*/10 * * * * cd /core && /usr/bin/env python3.7 /core/dummy-python.py > /var/log/cron.log 2>&1
```

## `Dockerfile` ##
The docker files needs to:
1. Install cron
2. Copy over the `.env` file with environemntal variables to `/etc/environment`.
3. Make it writeable for docker
4. Add it into cron with `crontab`
5. Create an empty log file called `cron.log`

## `docker-compose.yml` ##
Inside docker-compose we need to start cron and monitor content written to `/var/log/cron.log`

``` text
/etc/init.d/cron start && tail -f /var/log/cron.log
```

# Setting environmental variables #
When using an ubuntu image, write environemntal variables into `/etc/environment` - it will be loaded by cron when it starts.
