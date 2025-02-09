#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo "Welcome to My Salon, how can I help you?"
MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo -e "   $SERVICE_ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED

  # if SERVICE_ID_SELECTED is not a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    # send to main menu
    MAIN_MENU "I could not find that service. What would you like today?"
    
  # if SERVICE_ID_SELECTED is number
  else
    # get service availability
    SERVICE_AVAILABILITY=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECtED")

    # if not available
    if [[ -z $SERVICE_AVAILABILITY ]]
    then
      # send to main menu
      MAIN_MENU "I could not find that service. What would you like today?"
    else
    
    fi
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  
    # if CUSTOMER_ID is not found
    if [[ -z $CUSTOMER_ID ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      CUSTOMER_INPUT_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

      echo -e "\nWhat time would you like your $SERVICE_NAME, '$CUSTOMER_NAME'?"
      read SERVICE_TIME
      echo -e "\nI have put you down for a $SERVICE_NAME at '$SERVICE_TIME', '$CUSTOMER_NAME'."
    
    # if CUSTOMER_ID is found
    else
      CUS_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      echo -e "\nWhat time would you like your $SERVICE_NAME, '$CUS_NAME'?"
      read SERVICE_TIME
      echo -e "\nI have put you down for a $SERVICE_NAME at '$SERVICE_TIME', '$CUS_NAME'."
    fi
  fi
}

MAIN_MENU