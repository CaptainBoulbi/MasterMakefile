## gcc for c g++ foc c++
#compiler = g++
#obj = build/main.o build/monster.o
## -g for debug mode (for gbd) -O3 for release mod
#state = -g
#flag = -Wall -Weffc++ -Wextra -Wsign-conversion $(state)
#
#
#build/main : $(obj)
#	$(compiler) $(flag) -o build/main $(obj)
#
#build/main.o : src/main.cpp include/constant.hpp include/monster.hpp
#	$(compiler) $(flag) -c src/main.cpp -I include/ -o build/main.o
#
#build/monster.o : src/monster.cpp include/constant.hpp
#	$(compiler) $(flag) -c src/monster.cpp -I include/ -o build/monster.o
#
#.PHONY : obj-clean
#obj-clean :
#	rm build/*.o
#
#.PHONY : clean
#clean :
#	rm -r build/*
#
#.PHONY : run
#run : build/main
#	./build/main
#
#.PHONY : analyse
#analyse :
#	cppcheck --enable=all --suppress=missingIncludeSystem -I include/ .
#	flawfinder .

#
#BINARY=main
#CODEDIRS=. lib src
#INCDIRS=. ./include/ ./lib/ # can be list
#
#CC=g++
#EXT=c cpp
#OPT=-O0
## generate files that encode make rules for the .h dependencies
#DEPFLAGS=-MP -MD
## automatically add the -I onto each include directory
#CFLAGS=-Wall -Wextra -g $(foreach D,$(INCDIRS),-I$(D)) $(OPT) $(DEPFLAGS)
#
## for-style iteration (foreach) and regular expression completions (wildcard)
#CFILES=$(foreach E,$(EXT),$(foreach D,$(CODEDIRS),$(wildcard $(D)/**/*.$(E))))
## regular expression replacement
#OBJECTS=$(foreach E,$(EXT),$(patsubst %.$(E),%.o,$(CFILES)))
#DEPFILES=$(foreach E,$(EXT),$(patsubst %.$(E),%.d,$(CFILES)))
#
#all: $(BINARY)
#
#$(BINARY): $(OBJECTS)
#	$(CC) -o $@ $
#
## only want the .c file dependency here, thus $< instead of $^.
##
#%.o:$(foreach E,$(EXT),%.$(E))
#	$(CC) $(CFLAGS) -c -o $@ $<
#
#clean:
#	rm -rf $(BINARY) $(OBJECTS) $(DEPFILES) $(BINARY).tgz
#
## shell commands are a set of keystrokes away
#distribute: clean
#	tar zcvf $(BINARY).tgz *
#
## @ silences the printing of the command
## $(info ...) prints output
#diff:
#	$(info The status of the repository, and the volume of per-file changes:)
#	@git status
#	@git diff --stat
#
## include the dependencies
#-include $(DEPFILES)
#
## add .PHONY so that the non-targetfile - rules work even if a file with the same name exists.
#.PHONY: all clean distribute diff


PROJECTNAME=hamood
BIN=build/$(PROJECTNAME)
CC=g++
EXT=c cpp 
OPT=-Og -g
DEPFLAGS=-MP -MD
INCDIRS=. include lib extra
SRCFILES=$(foreach E,$(EXT),$(shell find . -name "*."$(E)))
#good luck to read this shit
OBJ=$(foreach O,$(filter %.o,$(foreach E,$(EXT),$(subst .$(E),.o,$(SRCFILES)))),$(shell echo $(O) | sed "s/^\\..*\//build\//g"))
#OBJ=$(patsubst ./%,build/%,$(filter %.o,$(foreach E,$(EXT),$(subst .$(E),.o,$(SRCFILES)))))
FLAGS=-Wall -Wextra $(foreach F,$(INCDIRS),-I$(F)) $(OPT) $(DEPFLAGS)


all : $(BIN)
#all :
#	$(info $(OBJ))

$(BIN) : $(OBJ)
	$(CC) $(FLAGS) -o $@ $^

$(OBJ) : $(SRCFILES)
	$(CC) $(FLAGS) -c -o $@ $<

run : all
	./$(BIN)

clean :
	rm -rf build/*

test :
	$(info file to test : $(file))

dist : clean
	tar zcvf build/$(PROJECTNAME).tgz *

analyse :
	cppcheck --enable=all --suppress=missingIncludeSystem -I include/ .
	flawfinder .

info :
	$(info project name : $(PROJECTNAME))
	$(info compiler : $(CC))
	$(info source file extension : $(EXT))
	$(info optimization flags : $(OPT))
	$(info )
	$(info git stat :)
	@gitinspector .

.PHONY : all run clean test dist analyse info
