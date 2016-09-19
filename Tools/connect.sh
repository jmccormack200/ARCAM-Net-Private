
#!/bin/bash
#connect.sh $1=user $2=pass $3=hostname

echo "Connnecting to $1@$3..."

ARCAM_UP="sudo -S bash ~/ARCAM-Net-Private/Tools/arcam_up.sh" 

$ARCAM_UP | ssh -tt -X $1@$3