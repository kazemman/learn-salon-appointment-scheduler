#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ My Salon ~~~~~\n"
echo "Weclome to Salon, How may I help you?"
#services
MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
   
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
   echo "$SERVICE_ID) $NAME service"
  done
  read SERVICE_ID_SELECTED
  HAVE_SERVICE_SELECTION=$($PSQL "SELECT service_id, name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $HAVE_SERVICE_SELECTION ]]
  then
     MAIN_MENU "I could not find that service. What would you like today?"
  else
    # get customer info
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    # if customer doesn't exist
     if [[ -z $CUSTOMER_NAME ]]
        then
         # get new customer name
          echo -e "I don't have a record for that phone number, what's your name?"
          read CUSTOMER_NAME
          # insert new customer
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")  

     fi
     # get customer_id
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
        SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    echo -e "\nWhat time would you like your $SERVICE_NAME service, $CUSTOMER_NAME?"
    read SERVICE_TIME
    INSERT_SERVICE_TIME=$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SERVICE_ID_SELECTED, $CUSTOMER_ID, '$SERVICE_TIME')")
  
   echo "What time would you like your $SERVICE_NAME, $SERVICE_TIME"
  
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    fi

}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}
MAIN_MENU
EXIT



