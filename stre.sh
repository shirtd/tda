#!/bin/bash

./tda.jl --test -n 10000 -k 10 -D 0 1 --run-raw
./tda.jl --test -n 10000 -k 10 -D 0 1 --run-k
./tda.jl --test -n 10000 -k 10 -D 0 1 --run-one

./tda.jl --test -n 20000 -k 20 -D 0 1 --run-raw
./tda.jl --test -n 20000 -k 20 -D 0 1 --run-k
./tda.jl --test -n 20000 -k 20 -D 0 1 --run-one

./tda.jl --test -n 40000 -k 40 -D 0 1 --run-raw
./tda.jl --test -n 40000 -k 40 -D 0 1 --run-k
./tda.jl --test -n 40000 -k 40 -D 0 1 --run-one

./tda.jl --test -n 60000 -k 60 -D 0 1 --run-raw
./tda.jl --test -n 60000 -k 60 -D 0 1 --run-k
./tda.jl --test -n 60000 -k 60 -D 0 1 --run-one

# NC='\033[0m'
# GRN='\033[0;32m'
# BLU='\033[0;34m'
# RED='\033[0;31m'
#
# printf "${RED}TEST${NC} ./tda --test"
# ./tda.jl --test
# printf "\n${RED}./tda --test${GRN} DONE${NC}\n"
#
# SEP="${RED}  ...  \t${GRN}"
#
# printf "\n$SEP -n 5000${NC}"
# ./tda.jl --test -n 5000
# printf "$SEP -k 2${NC}"
# ./tda.jl --test -n 5000 -k 2
# printf "$SEP -k 4${NC}"
# ./tda.jl --test -n 5000 -k 4
# printf "$SEP -k 6${NC}"
# ./tda.jl --test -n 5000 -k 6
# printf "$SEP -k 8${NC}"
# ./tda.jl --test -n 5000 -k 8
# printf "$SEP -k 10${NC}"
# ./tda.jl --test -n 5000 -k 10
# printf "$SEP -k 2-10${BLU}\n DONE\n"
