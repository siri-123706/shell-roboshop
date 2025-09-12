# #!/bin/bash

# START_TIME=$(date +%s)
# USERID=$(id -u) #user ID of the person running the script.UID=0, so this is used to check for root privileges.
# R="\e[31m" #Red usually for errors
# G="\e[32m" #Green (success messages)
# Y="\e[33m" #Yellow (warnings/info)
# N="\e[0m" #Reset (no color / default)

# LOGS_FOLDER="/var/log/roboshop-logs" #logs store to the folder
# SCRIPT_NAME=$(echo $0 | cut -d "." -f1) #echo $0 gives the script name mysql.sh
# LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" #Full path to the log file.
# SCRIPT_DIR=$PWD #present working directory 

# mkdir -p $LOGS_FOLDER #Ensures log directory exists (doesn't throw error if it already exists).
# echo "Script started executing at: $(date)" | tee -a $LOG_FILE #Prints and appends the log message to the log file.

# # check the user has root priveleges or not
# if [ $USERID -ne 0 ] #If the user is not root, show error and exit.
# then
#     echo -e "$R ERROR:: Please run this script with root access $N" | tee -a $LOG_FILE
#     exit 1 #give other than 0 upto 127
# else
#     echo "You are running with root access" | tee -a $LOG_FILE
# fi

# echo "Please enter root password to setup" #Prompts user to enter MySQL root password.

# # -s: Silent — input won't be displayed (for security).
# read -s MYSQL_ROOT_PASSWORD

# # validate functions takes input as exit status, what command they tried to install
# VALIDATE(){
#     if [ $1 -eq 0 ] #$1 0--> means success 
#     then
#         echo -e "$2 is ... $G SUCCESS $N" | tee -a $LOG_FILE #tee -a
#     else
#         echo -e "$2 is ... $R FAILURE $N" | tee -a $LOG_FILE
#         exit 1 #Logs either SUCCESS or FAILURE and stops the script if a command fails.
#     fi
# }

# dnf install mysql-server -y &>>$LOG_FILE
# VALIDATE $? "Installing MySQL server" #Checks if install was successful.

# systemctl enable mysqld &>>$LOG_FILE
# VALIDATE $? "Enabling MySQL"

# systemctl start mysqld   &>>$LOG_FILE
# VALIDATE $? "Starting MySQL"

# mysql_secure_installation --set-root-pass $MYSQL_ROOT_PASSWORD
# VALIDATE $? "Setting MySQL root password"

# END_TIME=$(date +%s)
# TOTAL_TIME=$(( $END_TIME - $START_TIME ))

# echo -e "Script exection completed successfully, $Y time taken: $TOTAL_TIME seconds $N" | tee -a $LOG_FILE


#!/bin/bash

START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p $LOGS_FOLDER
echo "Script started executing at: $(date)" | tee -a $LOG_FILE

# check the user has root priveleges or not
if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N" | tee -a $LOG_FILE
    exit 1 #give other than 0 upto 127
else
    echo "You are running with root access" | tee -a $LOG_FILE
fi

echo "Please enter root password to setup"
read -s MYSQL_ROOT_PASSWORD

# validate functions takes input as exit status, what command they tried to install
VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2 is ... $G SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "$2 is ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
}

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing MySQL server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabling MySQL"

systemctl start mysqld   &>>$LOG_FILE
VALIDATE $? "Starting MySQL"

mysql_secure_installation --set-root-pass $MYSQL_ROOT_PASSWORD &>>$LOG_FILE
VALIDATE $? "Setting MySQL root password"

END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))

echo -e "Script exection completed successfully, $Y time taken: $TOTAL_TIME seconds $N" | tee -a $LOG_FILE
