#!/bin/bash

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

i=0
passed=0
failed=0
interrupted=false
files=(tests/generated/*.yaml)
total=${#files[@]}

trap 'echo -e "\n${RED}🛑 Tests interrupted by user.${NC}"; interrupted=true; break' SIGINT

for f in "${files[@]}"; do
  i=$((i+1))
  name=$(basename "$f")
  echo -e "${YELLOW}🚀 [$i/$total] Running $name...${NC}"

  maestro test "$f"
  status=$?

  if [ $status -eq 0 ]; then
    echo -e "${GREEN}✅ [$i/$total] $name passed${NC}"
    passed=$((passed+1))
  elif [ $status -eq 130 ]; then
    echo -e "${RED}🛑 [$i/$total] $name interrupted${NC}"
    interrupted=true
    break
  else
    echo -e "${RED}❌ [$i/$total] $name failed (exit code $status)${NC}"
    failed=$((failed+1))
  fi

  echo "--------------------------------------"
done

echo
echo -e "${GREEN}🎉 Test session completed!${NC}"
echo "--------------------------------------"
echo -e "${GREEN}✅ Passed: $passed${NC}"
echo -e "${RED}❌ Failed: $failed${NC}"
[ "$interrupted" = true ] && echo -e "${YELLOW}⚠️ Interrupted at test $i of $total${NC}"
echo "--------------------------------------"

if [ "$interrupted" = true ]; then
  exit 130
elif [ $failed -gt 0 ]; then
  exit 1
else
  exit 0
fi
