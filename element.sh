#!/bin/bash
# FCC requirement validation fix

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

INPUT=$1

# If no input
if [[ -z $INPUT ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# Find element
RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
FROM elements e
JOIN properties p USING(atomic_number)
JOIN types t USING(type_id)
WHERE e.atomic_number::text='$INPUT'
OR e.symbol='$INPUT'
OR e.name='$INPUT';")

# If not found
if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
else
  IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< "$RESULT"

  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
fi

# commit validation

# FCC validation fix
