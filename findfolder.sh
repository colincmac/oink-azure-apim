LAST_PATH=$( git log --pretty="" --name-only -n 100 origin/main -- apis/**/* | head -1 )
echo Last file modified: $LAST_PATH
# Look for the main template file in this file's path or parents
SAMPLEFOLDER_PATH=$( dirname "$LAST_PATH" )
echo Last folder modified: $SAMPLEFOLDER_PATH
TESTFOLDER_PATH=$SAMPLEFOLDER_PATH
FOUNDFOLDER_PATH=
while [ "$TESTFOLDER_PATH" != "." ]
do
  echo "Looking for main template in $TESTFOLDER_PATH"
  MAINBICEP_PATH=$TESTFOLDER_PATH/main.bicep
  AZDEPLOYJSON_PATH=$TESTFOLDER_PATH/azuredeploy.json
  if [ -f "$MAINBICEP_PATH" ] || [ -f "$AZDEPLOYJSON_PATH" ]; then
    FOUNDFOLDER_PATH=$TESTFOLDER_PATH
    echo Found main template in $FOUNDFOLDER_PATH
    break
  fi
  TESTFOLDER_PATH=$( dirname "$TESTFOLDER_PATH" )
done
if [ ! $FOUNDFOLDER_PATH ]; then
    echo "Could not find main.bicep or azdeploy.json in folder or parents of $SAMPLEFOLDER_PATH" 1>&2
    exit 1
fi
echo "SAMPLEFOLDER_PATH=$FOUNDFOLDER_PATH" >> $GITHUB_ENV
echo "MAINBICEP_PATH=$MAINBICEP_PATH" >> $GITHUB_ENV
echo "AZDEPLOYJSON_PATH=$AZDEPLOYJSON_PATH" >> $GITHUB_ENV