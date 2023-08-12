#!/bin/sh

#  ci_pre_xcodebuild.sh
#  08_08_23_WeatherChallenge
#
#  Created by Jaden Nation on 8/12/23.
#

echo "Stage: PRE-Xcode Build is activated .... "

# Move to the place where the scripts are located.
# This is important because the position of the subsequently mentioned files depend of this origin.
cd $CI_WORKSPACE/ci_scripts || exit 1

# Write a JSON File containing all the environment variables and secrets.
printf "{\"OPENAI_KEY\":\"%s\"}" "$OPENAI_API_KEY" >> ../supportingfiles/secrets.json

echo "Wrote Secrets.json file."

echo "Stage: PRE-Xcode Build is DONE .... "

exit 0
