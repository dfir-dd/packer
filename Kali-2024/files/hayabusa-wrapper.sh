#!/bin/bash
#  hayabusa-wrapper.sh
#  Generic shell wrapper for hayabusa that adds the rules dir if not set for the needed commands

OPERATION=$(echo /opt/hayabusa/hayabusa-*-x64-gnu)
RULESFOLDER="/opt/hayabusa/rules"

if [[ "$*" == *"update-rules" ]]
then
    if [[ "$*" == *"-r "* ]] || [[ "$*" == *"help"* ]]
    then
        exec sudo $OPERATION $@
    else
        exec sudo $OPERATION $@ -r $RULESFOLDER
    fi
elif [[ "$*" == *"csv-timeline"* ]] || [[ "$*" == *"json-timeline"* ]]
then
    if [[ "$*" == *"-r "* ]] || [[ "$*" == *"help"* ]]
    then
        exec sudo $OPERATION $@
    else
        exec sudo $OPERATION $@ -r $RULESFOLDER
    fi
else
    exec $OPERATION $@
fi
