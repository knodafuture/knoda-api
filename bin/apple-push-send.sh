#!/bin/bash
RAKE_BIN="/home/user/.rvm/bin/rake-ruby-2.0.0-p247"
BASE_PATH="/home/user/knoda"
APNS_PATH="/home/user/knoda/tools/apns-send/apns-send/bin/Release"
APNS_SEND="mono /home/user/knoda/tools/apns-send/apns-send/bin/Release/apns-send.exe"
MESSAGES_FILE=/tmp/apple.push.messages
FAILED_FILE=/tmp/apple.push.failed

# Kill apns-send
APNS_PID=`ps aux | grep apns-send | grep -v "grep" | head -n 1 | awk '{print $2}'`

if [ -n "$APNS_PID" ]; then
    print "PID $APNS_SEND"
    kill -9 $APNS_PID
fi

# Reset messages file
echo > $MESSAGES_FILE

# Export push messages
(cd $BASE_PATH; $RAKE_BIN apns:export > $MESSAGES_FILE)

if [[ $? != 0 ]]; then
   echo "Error: exporting push messages"
   exit 1
fi

# Send Push notifications
cd $APNS_PATH
$APNS_SEND $MESSAGES_FILE 1>$FAILED_FILE

# Fix wrong tokens
(cd $BASE_PATH; $RAKE_BIN apns:process_failed file=$FAILED_FILE)


