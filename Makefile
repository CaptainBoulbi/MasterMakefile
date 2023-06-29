# It's the dumbest and ugliest makefile that i ever seen, it probably have a million way to improve it, but it work, and for only that reason, i'm happy
# note : malicious intent max

PROJECTNAME=hamood
BIN=build/$(PROJECTNAME)
CC=g++
EXT=c cpp 
OPT=-Og -g
DEPFLAGS=-MP -MD
EXTRAFLAGS=
INCDIRS=include lib extra
SRCDIR=src
TESTDIR=test
SRCFILES=$(foreach E,$(EXT),$(shell find . -name "*."$(E)))
# good luck to read this shit
OBJ=$(foreach O,$(filter %.o,$(foreach E,$(EXT),$(subst .$(E),.o,$(SRCFILES)))),$(shell echo $(O) | sed "s/^\\..*\//build\//g"))
FLAGS=-Wall -Wextra $(foreach F,$(INCDIRS),-I$(F)) $(OPT) $(DEPFLAGS) $(EXTRAFLAGS)
GREPFILE=$(shell echo $@ | sed 's/^.*\///g' | sed 's/\.o//g')
GREPOBJ=$(shell echo $^ | sed 's/build\///g' | sed 's/\.o//g')
SFILE=$(strip $(foreach S,$(SRCFILES),$(shell echo $(S) | grep $(GREPFILE) | grep ^\./$(SRCDIR)/)))
TFILE=$(strip $(foreach S,$(SRCFILES),$(shell echo $(S) | grep $(GREPFILE) | grep ^\./$(TESTDIR)/)))
PAIN=$

all : $(BIN)

$(BIN) : $(OBJ)
	$(CC) $(FLAGS) -o $@ $(strip $(foreach O,$(strip $(foreach S,$(SRCFILES),$(shell echo $(S) | grep \./$(SRCDIR)/ | sed "s/\.[^\.]*$(PAIN)//g" | sed "s/^.*\///g"))),$(foreach F,$(SRCFILES),$(shell echo $(F) | grep $(O)))))

$(OBJ) : $(SRCFILES)
	@[ "$(SFILE)" != "" ] && $(CC) $(FLAGS) -c -o $@ $(SFILE) || echo fail >/dev/null

run : all
	./$(BIN)

clean :
	rm -rf build/*

# make test file=test/testGenID.cpp
test : $(OBJ)
	$(info test main file : $(file))
	$(CC) $(FLAGS) -o build/test test/$(file)
	./build/test


dist : clean
	tar zcvf build/$(PROJECTNAME).tgz *

check :
	cppcheck --enable=all --suppress=missingIncludeSystem $(foreach I,$(INCDIRS),-I$(I)) .
	@echo
	@echo "\033[1;31m===============================================================================\033[0m"
	@echo
	flawfinder .

info :
	$(info compiler : $(CC))
	$(info source file extension : $(EXT))
	$(info optimization flags : $(OPT))
	$(info )
	$(info git stat :)
	@gitinspector . 2>/dev/null

.PHONY : all run clean test dist check info
