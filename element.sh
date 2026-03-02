#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ [0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
    if [[ ! -z $ATOMIC_NUMBER ]]
    then
    IFS="|" read SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $($PSQL "SELECT symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
    fi
  else
    NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1'")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'")
    if [[ ! -z $SYMBOL ]]
    then
      IFS="|" read NAME ATOMIC_NUMBER TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $($PSQL "SELECT name,atomic_number,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$SYMBOL'")
    elif [[ ! -z $NAME ]]
    then
      IFS="|" read SYMBOL ATOMIC_NUMBER TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $($PSQL "SELECT symbol,atomic_number,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name = '$NAME'")
    else
      echo "I could not find that element in the database."
      exit
    fi
  fi
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi
