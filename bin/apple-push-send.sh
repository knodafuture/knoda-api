#!/bin/bash
RAKE_BIN="/home/user/.rvm/bin/rake-ruby-2.0.0-p247"

BASE_PATH="/home/user/knoda"
APNS_SEND="mono /home/user/knoda/tools/apns-send/apns-send/bin/Release/apns-send.exe"
APNS_MODE="production"

CERT_FILE=/home/user/knoda/certs/APNs\ Production\ iOS.p12
CERT_PASS=ENTER_PASSWORD_HERE


if [ "$APNS_SANDBOX" = "yes" ]; then
    CERT_FILE=/home/user/knoda/certs/APNs\ Development\ iOS.p12
    CERT_PASS=111
    APNS_MODE=sandbox
else
    APNS_SANDBOX="no"
fi


MESSAGES_FILE=/tmp/knoda.apple.push.messages
FAILED_FILE=/tmp/knoda.apple.push.failed


MESSAGES_FILE=$MESSAGES_FILE.$APNS_MODE
FAILED_FILE=$FAILED_FILE.$APNS_MODE

# Kill apns-send
APNS_PID=`ps aux | grep apns-send | grep -v "grep" | head -n 1 | awk '{print $2}'`

if [ -n "$APNS_PID" ]; then
    print "PID $APNS_SEND"
    kill -9 $APNS_PID
fi

# Reset messages file
echo > $MESSAGES_FILE

# Export push messages
(cd $BASE_PATH; $RAKE_BIN apns:export sandbox=$APNS_SANDBOX > $MESSAGES_FILE)

if [[ $? != 0 ]]; then
   echo "Error: exporting push messages"
   exit 1
fi

# Send Push notifications
$APNS_SEND $APNS_MODE "$CERT_FILE" $CERT_PASS "$MESSAGES_FILE" 1>$FAILED_FILE

# Fix wrong tokens
(cd $BASE_PATH; $RAKE_BIN apns:process_failed file=$FAILED_FILE)


