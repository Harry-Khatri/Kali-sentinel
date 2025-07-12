#!/bin/bash

SCORE_FILE="./logs/threat_score.txt"
HISTORY_FILE="./logs/threat_score_history.csv"

DATE=$(date +'%Y-%m-%d %H:%M')

if [[ -f "$SCORE_FILE" ]]; then
    SCORE=$(cat "$SCORE_FILE")
    echo "$DATE,$SCORE" >> "$HISTORY_FILE"
fi

