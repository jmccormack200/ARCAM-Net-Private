
#!/bin/bash
#connect.sh $1=user $2=pass $3=hostname

echo "Connnecting to $1@$3..."

ARCAM_UP="sudo bash $(pwd)/arcam_up.sh" 

sshpass -p $2 ssh -tt -X $1@$3 $ARCAM_UP