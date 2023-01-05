#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
if [[ $1 ]]
then
  echo -e "\n$1"
fi

echo -e "\nWelcome to my salon, how many I help you?"
SERVICES_OFFERED=$($PSQL "SELECT * FROM services");
echo "$SERVICES_OFFERED" | while read SERVICE_ID bar SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

read SERVICE_ID_SELECTED

SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  if [[ -z $SELECTED_SERVICE ]]
  then
    MAIN_MENU "Please enter a valid service number."
  else
    echo -e "\nPlease enter your phone number"
    read CUSTOMER_PHONE
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone=$CUSTOMER_PHONE")
    if [[ -z $CUSTOMER_ID ]]
    then
     echo "\nPlease enter your name."
     read CUSTOMER_NAME
     INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi
    echo "\nPlease enter a service time in HH:MM format."
    read SERVICE_TIME
  fi

#Next step: Need to create a row in the appointments table.
#Need to if-else it for whether the phone number already exists.


}

MAIN_MENU