GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

i=0
total=$(ls tests/generated/*.yaml | wc -l)
for f in tests/generated/*.yaml; do
  i=$((i+1))
  name=$(basename "$f")
  echo -e "${YELLOW}🚀 [$i/$total] Running $name...${NC}"
  maestro test "$f"
  status=$?
  if [ $status -eq 0 ]; then
    echo -e "${GREEN}✅ [$i/$total] $name passed${NC}"
  else
    echo -e "${RED}❌ [$i/$total] $name failed (exit code $status)${NC}"
  fi
  echo "--------------------------------------"
done
echo -e "${GREEN}🎉 All $total tests completed!${NC}"
#todo add summary of passed/failed tests
