#!/bin/bash

DIFF_LOG=$(ls -t ./logs/diff_*.log | head -n1)

if [[ ! -f "$DIFF_LOG" ]]; then
  echo "[-] No diff logs found."
  exit 1
fi

SCORE=0

# Count new hosts
NEW_HOSTS=$(grep "^> " "$DIFF_LOG" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort -u | wc -l)
SCORE=$((SCORE + NEW_HOSTS * 10))

# Count dangerous ports
for port in 23 445 3306 3389; do
  COUNT=$(grep "^> " "$DIFF_LOG" | grep "$port/tcp" | wc -l)
  SCORE=$((SCORE + COUNT * 15))
done

# Cap max score
if (( SCORE > 100 )); then SCORE=100; fi

# Threat level
LEVEL="SAFE"
[[ $SCORE -gt 85 ]] && LEVEL="CRITICAL"
[[ $SCORE -gt 60 && $SCORE -le 85 ]] && LEVEL="HIGH"
[[ $SCORE -gt 25 && $SCORE -le 60 ]] && LEVEL="MODERATE"

echo "$SCORE [$LEVEL]"
echo "$SCORE [$LEVEL]" > ./logs/threat_score.txt
