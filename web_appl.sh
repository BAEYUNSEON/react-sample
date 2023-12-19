#!/bin/sh

#BASE_PATH=.
BASE_PATH="/home/76903117/vm-deploy/react-sample"
echo $BASE_PATH

##Logging
#PIDDIR="."
PIDDIR=$BASE_PATH
PIDFILE="$PIDDIR/app.pid"
WEB_PORT=8096

pid=""
CMD_NAME="python3"
CMD_EXE="nohup $CMD_NAME -m http.server $WEB_PORT --directory $BASE_PATH/build >> $LOG_PATH/$LOG_FILE 2>&1 &"

getpid() {
    if [ -f "$PIDFILE" ]
    then 
        if [ -r "$PIDFILE" ]
        then 
            pid=`cat "$PIDFILE"`
            if [ "X$pid" != "X" ]
            then 
                pidtest=`ps -p $pid -o args | grep $CMD_NAME | tail -1`
                if [ "X$pidtest" = "X" ]
                then 
                    rm -f "$PIDFILE"
                    echo "Delete pid file"
                    pid=""
                fi
            fi 
        fi 
    fi 
}

testpid() {
    pid=`ps -f $pid | grep $pid | grep -v grep | awk '{print $1}' | tail -1`
    if [ "X$pid" = "X" ]
    then    
        eval $CMD_EXE
        echo $! > $PIDFILE
    else
        echo "Application alread running..."
        exit 1
    fi 
    #sleep 10 
    sleep 1
    getpid
    echo $pid
    if [ "X$pid" != "X" ]
    then 
        echo "Application Started!!"
    else
        echo "Application did not start after 10 seconds. check $LOG_PATH/$LOG_FILE"
    fi 
}

stopit() {
    echo "Stopping Application..."
    getpid
    if [ "X$pid" = "X" ]
    then
        echo "Application not running"
    else
        kill $pid
        if [ $? -ne 0 ]
        then 
            echo "Unable to stop application"
            exit 1
        fi 

        savepid=$pid
        CNT=0
        TOTCNT=0
        while [ "X$pid" != "X" ]
        do 
            # show a waiting message every 5 seconds.
            if [ "$CNT" -lt "5" ]
            then
                CNT=`expr $CNT +1`
            else 
                echo "Waiting for application to exit..."
                CNT=0
            fi 
            TOTCNT=`expr $TOTCNT +1`
            sleep 1
            testpid
        done

        pid=$savepid
        testpid
        if [ "X$pid" != "X" ]
        then 
            echo "Failed to stop application"
            exit 1
        else 
            echo "Stopped application"
        fi 
    fi 
}

status() {
    getpid
    if [ "X$pid" = "X" ]
    then 
        echo "Application is not running"
        exit 1
    else
        echo "Application is running ($pid)"
        exit 0
    fi 
}

case "$1" in 
    'start')
        start
        ;;

    'stop')
        stopit
        ;;

    'restart')
        stopit
        start
        ;;

    'status')
        status
        ;;
    *)
    echo "Usage: $0 {start | stop | restart | status }"
    exit 1
esac

exit 0