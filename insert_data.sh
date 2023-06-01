#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams")"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# Get team names
  if [[ $WINNER != "winner" ]]
  then
    # select winner team names
    WINNER_TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name=''$WINNER")
    # if team name not found
    if [[ -z $WINNER_TEAM_NAME ]] 
    then
      #insert team names
      INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_TEAM == "INSERT 0 1" ]]
      then 
        echo Inserted team $WINNER
      fi
    fi
  fi
  if [[ $OPPONENT != "opponent" ]]
  then
    #select opponent team names
    OPPONENT_TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    # if opp team not found
    if [[ -z $OPPONENT_TEAM_NAME ]]
    then
    # insert team names
      INSET_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_NAME == "INSERT 0 1" ]]
      then
        echo Inserted team $OPPONENT
      fi
    fi
  fi    


  #Get game data
  if [[ $YEAR != "year" ]]
  then
  #get winner_Id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  #get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  # insert game data
    INSERT_GAME_DATA=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR,'$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ INSERT_GAME_DATA == "INSERT 0 1" ]]
    then  
      echo New game added: $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, score $WINNER_GOALS : $OPPONENT_GOALS
    fi
  fi  

done


