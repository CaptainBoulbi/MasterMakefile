# It's the dumbest and ugliest makefile that i ever seen, it probably have a million way
# to improve it, but it work, and for only that reason, i'm happy
# note : malicious intent max
# update : it's better now

PROJECTNAME=OMTRTA
BIN=$(BUILDDIR)/$(PROJECTNAME)
CC=g++

OPT=-Og -g
EXTRAFLAGS=
DEPFLAGS=-MP -MD
FLAGS=-Wall -Wextra $(foreach F,$(INCDIRS),-I$(F)) $(OPT) $(DEPFLAGS) $(EXTRAFLAGS)

INCDIRS=include lib extra
SRCDIR=src
BUILDDIR=build
TESTDIR=test

EXT=cpp c
SRC=$(foreach E,$(EXT),$(shell find . -name "*."$(E) -path "./$(SRCDIR)/*"))
FILE=$(foreach S,$(SRC),$(shell echo "$(S)" | sed "s/\.\/.*\///g" | sed "s/\.[^.]*$$//g"))
OBJ=$(foreach F,$(FILE),./$(BUILDDIR)/$(F).o)

all : $(BIN)

$(BIN) : $(OBJ)
	$(CC) $(FLAGS) -o $(BIN) $^

$(OBJ) : $(SRC)
	$(CC) $(FLAGS) -c -o $@ $<

run : all
	./$(BIN)

clean :
	rm -r $(BUILDDIR)/*

# make test file=testGenID.cpp
test : $(OBJ) $(TESTDIR)/$(file)
	$(CC) $(FLAGS) -o $(BUILDDIR)/test $(TESTDIR)/$(file)
	./$(BUILDDIR)/test

# unzip : tar -xvf exemple.tgz
# -C flag to unzip in an other folder
dist : clean
	tar zcvf $(BUILDDIR)/$(PROJECTNAME).tgz *

check :
	cppcheck --enable=all --suppress=missingIncludeSystem $(foreach I,$(INCDIRS),-I$(I)) .
	flawfinder .

info :
	$(info put what ever)
	@echo you want

.PHONY : all run clean test dist check info
