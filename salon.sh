#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Hair Salon ~~~~~"
echo -e "\nHere are the available services:\n"

while true
do

# Display list of services
SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
do
  echo "$SERVICE_ID) $SERVICE_NAME"
done
#Ask for user choice
echo -e "\nSelect service number:"
read SERVICE_ID_SELECTED
# List valid input
SERVICE_ID_VALID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
# User input is bullshit ? 
if [[ -z $SERVICE_ID_VALID ]]
then
  echo -e "\nInvalid service number"
else 
  break # Sortie de la boucle car la sélection est valide
fi  
done

#Ask for user phone number
echo -e "\n what is your phone number ?"
read CUSTOMER_PHONE

# Find if it is aknow customer
FIND_USER=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
# User doesn't exist
if [[ -z $FIND_USER ]]
then
echo -e "\nHey you're new ! What's your name ?"
read CUSTOMER_NAME
# Insert new user
INSERT_USER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi
# Ask for the time
echo "What time do you wish ?"
read SERVICE_TIME
# Get the old or newly created customer_id
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
# Insert the new appointment
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
# Vérification du succès de l'insertion
if [[ $INSERT_APPOINTMENT == "INSERT 0 1" ]]
then
  echo "Appointment successfully created."
else
  echo "Something wrong !"
fi

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."


EXIT() {
  echo -e "\nSee you soon.\n"
}