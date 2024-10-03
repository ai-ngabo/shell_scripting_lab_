#Creating the main directory
mkdir submission_reminder_app/

#Adding sub-directories and startup bash file to the main directory
mkdir -p submission_reminder_app/app/
mkdir -p submission_reminder_app/modules/ 
mkdir -p submission_reminder_app/assets/
mkdir -p submission_reminder_app/config/
touch submission_reminder_app/startup.sh

echo "subdirectories were created"

#creating files inside sub-directories
touch submission_reminder_app/app/reminder.sh
touch submission_reminder_app/modules/functions.sh
touch submission_reminder_app/assets/submissions.txt
touch submission_reminder_app/config/config.env

echo "Files successfully created"

#Adding content for the reminder.sh file
echo '#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file' > submission_reminder_app/app/reminder.sh

#Adding content for the functions bash file

echo '#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}' > submission_reminder_app/modules/functions.sh

#Adding config.env file's content

echo 'ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2' > submission_reminder_app/config/config.env

#Creating the script inside the startup.sh to run reminder.sh's contents

echo '#!/bin/bash

#Checking if the directory is correct
cd "$(dirname "$0")"

#Running the reminder app
echo "Starting the reminder app ....."

#Executing the reminder app
bash ./app/reminder.sh

echo "Reminder app executed successfully"' > submission_reminder_app/startup.sh

#Adding 5 more students record inside sudmissions.txt

echo <<EOL >> submission_reminder_app/assets/submissions.txt
Student Name, Assignment, Status
Alan, Shell Navigation, submitted
Myla, Shell Navigation, not submitted
Steven, Shell Navigation, submitted
Jacob, Shell Navigation, not submitted
Bob, Shell Navigation, submitted
EOL

echo "New student records was submitted!"

chmod +x submission_reminder_app/startup.sh
