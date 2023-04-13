//compiler :
//echo && g++ test/testGenID.cpp -o build/test -I include/ && ./build/test


#include <iostream>
#include <cassert>
#include "constant.hpp"
void test1_1(){
	assert(genID() == 4);
	assert(genID() == 5);
	assert(genID() == 6);
}

void test1(){
	assert(genID() == 1);
	assert(genID() == 2);
	assert(genID() == 3);

	test1_1();
}

int main(){
	std::cout << "[ \033[1;32mTEST\033[0m ]" << std::endl;

	test1();

	std::cout << "[ \033[1;93mSUCCESS\033[0m ]" << std::endl;
	return 0;
}
