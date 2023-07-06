# It's the dumbest and ugliest makefile that i ever seen, it probably have a million way to improve it, but it work, and for only that reason, i'm happy
# note : malicious intent max
# update : it's better now

PROJECTNAME=OMTRTA
BIN=build/$(PROJECTNAME)
CC=g++

OPT=-Og -g
EXTRAFLAGS=
DEPFLAGS=-MP -MD
FLAGS=-Wall -Wextra $(foreach F,$(INCDIRS),-I$(F)) $(OPT) $(DEPFLAGS) $(EXTRAFLAGS)

INCDIRS=include lib extra
SRCDIRS=src lib extra

EXT=cpp c
SRC=$(foreach S,$(SRCDIRS),$(foreach E,$(EXT),$(shell find . -name "*."$(E) -path "./$(S)/*")))
FILE=$(shell echo $(SRC) | tr ' ' '\n' | sed "s/\.\/.*\///g" | sed "s/\.[^.]*$$//g")
OBJ=$(foreach F,$(FILE),./build/$(F).o)

all : $(BIN)

$(BIN) : $(OBJ)
	$(CC) $(FLAGS) -o $(BIN) $(OBJ)

$(OBJ) : $(shell echo "$(SRC)" | grep -o "[^ ]*$(word $(call pos,$@,$(OBJ)),$(FILE))[^ ]*")
	$(CC) $(FLAGS) -c -o $@ $<

run : all
	./$(BIN)

clean :
	rm -r build/*

# make test file=testGenID.cpp
test : $(OBJ) test/$(file)
	$(CC) $(FLAGS) -o build/test test/$(file)
	./build/test

# unzip : tar -xvf exemple.tgz
# -C flag to unzip in an other folder
dist : clean
	tar zcvf build/$(PROJECTNAME).tgz *

check :
	cppcheck --enable=all --suppress=missingIncludeSystem $(foreach I,$(INCDIRS),-I$(I)) .
	flawfinder .

info :
	$(info put what ever)
	@echo you want

.PHONY : all run clean test dist check info
