# gcc for c g++ foc c++
compiler = g++
obj = build/main.o build/monster.o
# -g for debug mode (for gbd) -O3 for release mod
state = -g
flag = -Wall -Weffc++ -Wextra -Wsign-conversion $(state)


build/main : $(obj)
	$(compiler) $(flag) -o build/main $(obj)

build/main.o : src/main.cpp include/constant.hpp include/monster.hpp
	$(compiler) $(flag) -c src/main.cpp -I include/ -o build/main.o

build/monster.o : src/monster.cpp include/constant.hpp
	$(compiler) $(flag) -c src/monster.cpp -I include/ -o build/monster.o

.PHONY : clean
clean :
	rm -r build/*

.PHONY : run
run : build/main
	./build/main

.PHONY : analyse
analyse :
	cppcheck --enable=all --suppress=missingIncludeSystem -I include/ .
	flawfinder .
