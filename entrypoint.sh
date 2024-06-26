#!/bin/sh
msmtpd "$@" &
pid=$!
trap 'kill $pid' HUP INT QUIT TERM
wait $pid
