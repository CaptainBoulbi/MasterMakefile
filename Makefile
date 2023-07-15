PROJECTNAME=OMTRTA
BIN=build/$(PROJECTNAME)
CC=g++

EXT=cpp
INCFOLDERS=include lib
INCDIRS=$(foreach I,$(INCFOLDERS),$(shell find $(I) -type d))

# make mode=release
ifeq ($(mode), release)
	OPT=-O3
else
	OPT=-Og -g
endif
DEPFLAGS=-MP -MD
FLAGS=-Wall -Wextra $(foreach F,$(INCDIRS),-I$(F)) $(OPT) $(DEPFLAGS)

SRC=$(shell find . -name "*.$(EXT)" -path "./src/*")
OBJ=$(subst ./src/,./build/,$(SRC:.$(EXT)=.o))
DEP=$(OBJ:.o=.d)
ASM=$(OBJ:.o=.asm)
TEST=$(shell find . -name "*.$(EXT)" -path "./test/*")

$(shell mkdir -p build)

all : $(BIN)

$(BIN) : $(OBJ)
	$(CC) $(FLAGS) -o $@ $^

-include $(DEP)

build/%.o : src/%.$(EXT)
	@mkdir -p $(@D)
	$(CC) $(FLAGS) -o $@ -c $<

run : all
	./$(BIN) $(input)

clean :
	rm -rf build/*

# make test file=testGenID.cpp
test : build/$(file:.$(EXT)=.test)
	./build/$(file:.$(EXT)=.test)

alltest : $(subst ./test/,./build/,$(TEST:.$(EXT)=.test))
	for i in $$(ls build/*.test); do echo $$i; $$i; done

build/%.test : test/%.$(EXT)
	@mkdir -p $(@D)
	$(CC) $(FLAGS) -o $@ $<

check :
	cppcheck --enable=all --suppress=missingIncludeSystem $(foreach I,$(INCDIRS),-I$(I)) .
	flawfinder .

info :
	$(info put what ever)
	@echo you want

# unzip : tar -xvf exemple.tgz
dist : clean
	$(info /!\ project folder has to be named $(PROJECTNAME) /!\ )
	cd .. && tar zcvf $(PROJECTNAME)/build/$(PROJECTNAME).tgz $(PROJECTNAME) >/dev/null

asm : $(ASM) $(BIN)
	objdump -drwC -Mintel -S $(BIN) > $(BIN).asm

build/%.asm : src/%.$(EXT)
	@mkdir -p $(@D)
	$(CC) $(FLAGS) -S $^ -o $@

debug : $(BIN)
	gdb $(BIN) $(input)

.PHONY : all run clean test alltest check info dist asm debug
