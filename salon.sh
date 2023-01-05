#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

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

SERVICE_ID_FROM_DB=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
  if [[ -z $SERVICE_ID_FROM_DB ]]
  then
    MAIN_MENU "Please enter a valid service number."
  else
    echo -e "\nPlease enter your phone number"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")
    if [[ -z $CUSTOMER_NAME ]]
    then
     echo -e "\nPlease enter your name."
     read CUSTOMER_NAME
     INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo -e "\nPlease enter a service time."
    read SERVICE_TIME
    INSERT_APT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, '$SERVICE_ID_FROM_DB', '$SERVICE_TIME')")
    CHOSEN_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_FROM_DB")
    echo -e "I have put you down for a $CHOSEN_SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
  fi
}

MAIN_MENU