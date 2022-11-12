#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align --tuples-only -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align --tuples-only -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
  TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  if [[ $WINNER != "winner" ]]
  then
  if [[ -z $TEAM ]]
    then
    INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
    if [[ INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi
  fi
  TEAMS2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
  if [[ $OPPONENT != "opponent" ]]
  then
  if [[ -z $TEAMS2 ]]
    then
    INSERT_TEAMS2=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
     if [[ INSERT_TEAMS2 == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
  fi
  TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")
  TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")
  echo $TEAM_ID_WINNER $TEAM_ID_OPPONENT

  if [[ -n $TEAM_ID_WINNER || -n $TEAM_ID_OPPONENT ]]
  then
    if [[ $YEAR != "year" ]]
    then
      INSERT_GAMES=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_WINNER, $TEAM_ID_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ $INSERT_GAMES == "INSERT 0 1" ]]
      then
      echo Inserted into games, $YEAR
      fi
    fi
  fi
done
