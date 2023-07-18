PROJECTNAME=OMTRTA
BIN=build/$(PROJECTNAME)
CC=g++

EXT=cpp
INCFOLDERS=include lib
RECURSIVE_INCLUDE=false
ifeq ($(RECURSIVE_INCLUDE),true)
	INCDIRS=$(foreach I,$(INCFOLDERS),$(shell find $(I) -type d 2>/dev/null))
else
	INCDIRS=$(INCFOLDERS)
endif

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
LIB=$(shell find . -name "*.$(EXT)" -path "./lib/*")
LIBO=$(subst ./lib/,./build/,$(LIB:.$(EXT)=.o))
DEP=$(OBJ:.o=.d)
ASM=$(OBJ:.o=.s)
TEST=$(shell find . -name "*.$(EXT)" -path "./test/*")
TESTO=$(subst ./test/,./build/,$(TEST:.$(EXT)=.t))

$(shell mkdir -p build)

all : $(BIN)

$(BIN) : $(OBJ) $(LIBO)
	$(CC) $(FLAGS) -o $@ $^

-include $(DEP)

build/%.o : src/%.$(EXT)
	@mkdir -p $(@D)
	$(CC) $(FLAGS) -o $@ -c $<
build/%.o : lib/%.$(EXT)
	@mkdir -p $(@D)
	$(CC) $(FLAGS) -o $@ -c $<

run : $(BIN)
	./$(BIN) $(input)

clean :
	rm -rf build/*

# make test file=testGenID.cpp
test : build/$(file:.$(EXT)=.t)
	./build/$(file:.$(EXT)=.t)

alltest : $(TESTO)
	@for i in $(TESTO); do echo $$i; $$i; done

build/%.t : test/%.$(EXT)
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

gigall : $(BIN) asm preprocess $(TESTO)

install : dist
	cp Makefile ../script
	mv build/OMTRTA.tgz ../opt/archive
	cd .. && rm -rf OMTRTA

push :
	git push bbsrv
	git push gh

.PHONY : all run clean test alltest check info dist asm debug preprocess gigall install push
