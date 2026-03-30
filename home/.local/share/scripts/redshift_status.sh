#!/bin/bash

STATUS=$(redshift -p 2>/dev/null)

if echo "$STATUS" | grep -q 'Period: Night'; then
  echo "🌙 3400K"
elif echo "$STATUS" | grep -q 'Period: Day'; then
  echo "☀️ 5500K"
else
  echo "🛑"
fi

