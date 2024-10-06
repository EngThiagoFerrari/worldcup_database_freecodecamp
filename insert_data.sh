#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games;")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do  
  if [[ $YEAR != 'year' ]]
  then
    # check if the winner is already inserted into the teams table
    TEAM_ID_WIN=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM_ID_OPP=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # inserting winners if not inserted
    if [[ -z $TEAM_ID_WIN ]]
    then
      TEAM_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $TEAM_INSERT == 'INSERT 0 1' ]]
      then
        echo Inserted team: $WINNER
      fi
    fi
    # getting the winner id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #echo $WINNER_ID

    # inserting the opponents if not inserted
    if [[ -z $TEAM_ID_OPP ]]
    then
      TEAM_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $TEAM_INSERT == 'INSERT 0 1' ]]
      then
        echo Inserted team: $OPPONENT
      fi
    fi
    # getting the opponent id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #echo $OPPONENT_ID


    #inserting the data into the games table
    GAME_INS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $GAME_INS == "INSERT 0 1" ]]
    then
      echo $ROUND : $WINNER
    fi

  fi
done