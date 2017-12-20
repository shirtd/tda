#!/bin/bash
NC='\033[0m'
GRN='\033[0;32m'
BLU='\033[0;34m'
RED='\033[0;31m'

printf "\n${RED}TEST${NC} ./tda --test"
./tda.jl --test
printf "${RED}./tda --test${GRN}DONE${NC}\n"

printf "\n${RED}...${GRN} -n 5000${NC}"
./tda.jl --test -n 5000
printf " ${GRN}...${BLU} -k 2${NC}"
./tda.jl --test -n 5000 -k 2
printf " ${GRN}...${BLU} -k 4${NC}"
./tda.jl --test -n 5000 -k 4
printf " ${GRN}...${BLU} -k 6${NC}"
./tda.jl --test -n 5000 -k 6
printf " ${GRN}...${BLU} -k 8${NC}"
./tda.jl --test -n 5000 -k 8
printf " ${GRN}...${BLU} -k 10${NC}"
./tda.jl --test -n 5000 -k 10
printf "${GRN} -n 10000 ${BLUE} -k 2-10 ${NC} DONE\n"
