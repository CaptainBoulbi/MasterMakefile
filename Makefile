ROJECTNAME=OMTRTA
BIN=build/$(ROJECTNAME)
CC=g++

EXT=cpp
INCDIRS=include lib

# make mode=release
ifneq ($(mode), release)
	OPT=-Og -g
else
	OPT=-O3
endif
EXTRAFLAGS=
DEPFLAGS=-MP -MD
FLAGS=-Wall -Wextra $(foreach F,$(INCDIRS),-I$(F)) $(OPT) $(DEPFLAGS) $(EXTRAFLAGS)

SRC=$(shell find . -name "*.$(EXT)" -path "./src/*")
OBJ=$(subst ./src/,./build/,$(SRC:.$(EXT)=.o))
DEP=$(OBJ:.o=.d)

$(shell mkdir -p build)

all : $(BIN)

$(BIN) : $(OBJ)
	$(CC) $(FLAGS) -o $@ $^

-include $(DEP)

build/%.o: src/%.$(EXT)
	@mkdir -p $(@D)
	$(CC) $(FLAGS) -o $@ -c $<

run : all
	./$(BIN)

clean :
	rm -rf build/*

# make test file=testGenID.cpp
test : $(OBJ) test/$(file)
	$(CC) $(FLAGS) -o build/$(file:.$(EXT)=) test/$(file)
	./build/$(file:.$(EXT)=)

# unzip : tar -xvf exemple.tgz
dist : clean
	tar zcvf build/$(PROJECTNAME).tgz *

check :
	cppcheck --enable=all --suppress=missingIncludeSystem $(foreach I,$(INCDIRS),-I$(I)) .
	flawfinder .

info :
	$(info put what ever)
	@echo you want

.PHONY : all run clean test dist check info
