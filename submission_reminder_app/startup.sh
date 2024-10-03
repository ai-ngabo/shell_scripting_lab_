#!/bin/bash

#Checking if the directory is correct
cd "$(dirname "$0")"

#Running the reminder app
echo "Starting the reminder app ....."

#Executing the reminder app
bash ./app/reminder.sh

echo "Reminder app executed successfully"
