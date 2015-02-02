#!/bin/bash
### BEGIN INIT INFO
# Provides:          ravnd
# Required-Start:    networking
# Required-Stop:     
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Manages RAVN Server
# Description:       Manages the RAVN Server, autostarts the server on any USB device, and if sucessful
#                    exits the script, otherwise quits it and restarts it on the next available USB device
#                    `pidfile` & `server` get replaced by actual file paths when you run the install.sh script
### END INIT INFO
start() {
    shopt -s nullglob
    a=(/dev/ttyA*)
    b=(/dev/ttyU*)
    shopt -u nullglob
    array=("${a[@]}" "${b[@]}")
    for x in $array
    do
        echo "starting RAVN Server on device: $x"
        > PIDFILE
        screen -s /bin/bash -d -m mavproxy.py --master=$x --cmd="module load droneapi.module.api; api start SERVER"
        sleep 15
        if [ -s PIDFILE ]
        then
            echo "PIDFile found, Server Up. PID:$(cat PIDFILE)"
            return 0;
        else
            echo "PIDFile empty, killing rouge servers"
            killall -9 mavproxy.py
        fi
    done
}
stop() {
    if [ -s PIDFILE ]
    then
        echo "PIDFile found, Server going down. PID:$(cat PIDFILE)"
        kill -9 $(cat PIDFILE)
    else
        echo "PIDFile empty, killing rouge servers"
        killall -9 mavproxy.py
    fi
    > PIDFILE
}
### main logic ###
case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart|reload|condrestart)
        stop
        start
        ;;
  *)
        echo $"Usage: $0 {start|stop|restart|reload}"
        exit 1
esac
exit 0