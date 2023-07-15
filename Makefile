PROJECTNAME=OMTRTA
BIN=build/$(PROJECTNAME)
CC=g++

EXT=cpp
INCFOLDERS=include lib
INCDIRS=$(foreach I,$(INCFOLDERS),$(shell find $(I) -type d 2>/dev/null))

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
ASM=$(OBJ:.o=.s)
TEST=$(shell find . -name "*.$(EXT)" -path "./test/*")
TESTO=$(subst ./test/,./build/,$(TEST:.$(EXT)=.test))

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

alltest : $(TESTO)
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

asm : $(ASM) $(BIN) $(BIN).s

build/%.s : src/%.$(EXT)
	@mkdir -p $(@D)
	$(CC) $(FLAGS) -S $^ -o $@

$(BIN).s :
	objdump -drwC -Mintel -S $(BIN) > $(BIN).s

debug : $(BIN)
	gdb $(BIN) $(input)

preprocess : $(OBJ:.o=.i)

build/%.i : src/%.$(EXT)
	@mkdir -p $(@D)
	$(CC) $(FLAGS) -E $^ -o $@

gigall : all asm preprocess $(TESTO)

install : dist
	cp Makefile ../script
	mv build/OMTRTA.tgz ../opt/archive
	cd .. && rm -rf OMTRTA

push :
	git push bbsrv
	git push gh

.PHONY : all run clean test alltest check info dist asm debug preprocess gigall install push
