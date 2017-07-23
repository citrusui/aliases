#!/usr/bin/env bash

# TODO: color!

if [ "$TRAVIS_OS_NAME" == "linux" ]; then
  shellcheck init.sh
fi

source .aliases # expand aliases so we can test them

ali=("-" ".." "..." "...." "~" "atom" "cch" "sh" "sudo" "upd") # alias names
ali2=("cd -" "cd .." "cd ../.." "cd ../../.." "cd ~" "atom -a" "cache" "bash" "sudo " "update") # alias values

echo ""

for index in ${!ali[*]}; do # loop through both arrays ($ali, $ali2).
  out=`alias "${ali[$index]}" | grep -Po "'.*?'"` # strip out everything besides stuff in 'quotes'.
  if [ "$(alias ${ali[$index]})" != "alias ${ali[$index]}='${ali2[$index]}'" ]; then # if the alias name ($ali) does not equal to the alias value ($ali2), continue.
    echo -e "\033[1;31mERR: '${ali[$index]}' == $out. Expected '${ali2[$index]}'.\033[0m" # print alias name and value, and return the expected value.
    export fail="true" # make a note that a test has failed.
  else
    echo -e "\033[1;32mOK:  '${ali[$index]}' == $out\033[0m" # mark aliases that produce correct values as OK.
  fi
done

echo ""

if [ "$fail" == "true" ]; then
  echo "Some or all tests failed."
  exit 1
else
  echo "All tests passed!"
fi
