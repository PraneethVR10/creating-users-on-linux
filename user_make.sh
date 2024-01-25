#!/bin/bash

#Script should be executed with sudo/root access
if [[ "${UID}" -ne 0 ]]
then 
     echo 'Please run with the sudo command in front of the file name'
     exit 1
fi
 # User should provide atleast one argument as username else guide them
if  [[ "${#}" -lt 1 ]]
then 
      echo "Usage: ${0} USER_NAME [COMMENT]...."
      echo 'Create a user with name USER_NAME and add some comments in the comments field'
      exit 1
fi
# Store First argument as the USER NAME
USER_NAME="${1}"
echo $USER_NAME

# In case of more than one argument, Store it as a comment
shift
COMMENT="${@}"

#create a Password
PASSWORD=$(date +%s%N)
echo $PASSWORD

#create the user
useradd -c "${COMMENT}" -m $USER_NAME

#check if user is successfully created or not
if [[ $? -ne 0 ]]
then  
     echo 'The Account could not be created successfully'
     exit 1
fi

#set the Password for the user
echo "${USER_NAME}:${PASSWORD}" | chpasswd

#check if password is succesfully set or not
if [[ $? -ne 0 ]]
then 
     echo 'Password could not be set successfully'
     exit 1
fi

#force password change on first login
passwd -e $USER_NAME 

# Display the Username, Password and the host where the user was created
echo 
echo "Username: $USER_NAME"
echo
echo "Password: $PASSWORD"
echo
echo $(hostname)

