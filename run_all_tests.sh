#! /bin/bash

# ROOT_FOLDER for everything
ROOT_FOLDER=/home/ubuntu

# blacklist :
#blacklist=`bhbaker-blazarus-ps2 czhao-heyitsye-ps2 hyuen-gelash-ps2 johnnyb-ameesh-ps2 mattocks-badar-kjw-ps2 ravinet-yuhan-ps2 rterbush-ps2 shalev-belinkov-ps2`

# White list of all working submissions
if [ $# -ne 1 ]; then
  echo "Enter whitelist"
  exit
fi
source $1
echo "Whitelist is $whitelist"

# bring repo to consistent state
cd $ROOT_FOLDER/contest
git checkout -- .
cd $ROOT_FOLDER/multisend
cd sender
make clean
cd ..
git checkout -- .
cd $ROOT_FOLDER/datagrump
make clean
git checkout -- .
cd $ROOT_FOLDER
./update-git-repos

# copy modified version of cellsim-runner.sh
if [ $2 -eq "test" ];
  echo "Picking testing trace, copy cellsim-runner.sh"
  cp cellsim-runner.sh $ROOT_FOLDER/multisend/sender
fi;

# clone submissions
cd $ROOT_FOLDER
rm -rf $ROOT_FOLDER/results
mkdir results
git clone https://github.com/keithw/datagrump-students

# clone 6829 web
git clone https://github.com/keithw/6829-web

# list all tags
for tag in `echo $whitelist`; do
  # Go to datagrump-students
  cd $ROOT_FOLDER/datagrump-students

  # Remove all untracked files
  git clean -xfd

  # Check out tag
  echo "Tag name is $tag"
  git reset --hard $tag

  # Clean again.
  git clean -xfd

  # Remove datagrump-sender and datagrump-receiver
  rm -rf datagrump-sender datagrump-receiver

  # Make clean and make
  make clean > /dev/null
  make > /dev/null

  # Copy to right location
  rm $ROOT_FOLDER/datagrump/datagrump-sender $ROOT_FOLDER/datagrump/datagrump-receiver
  cp datagrump-sender $ROOT_FOLDER/datagrump
  cp datagrump-receiver $ROOT_FOLDER/datagrump

  # Run 3 iterations
  echo "Make result $?"
  cd $ROOT_FOLDER/contest

  j=0;
  while [ $j -lt 3 ]; do

    sudo ./run-trial.py $tag-iter$j

    # Generate stats
    $ROOT_FOLDER/6829-web/stats /tmp/to-upload.gz $tag-iter$j.html
    mv $tag-iter$j.html $ROOT_FOLDER/results/

    j=`expr $j '+' 1`
  done

  echo ""
  echo ""
  echo ""
done
