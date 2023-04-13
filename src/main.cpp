#include <iostream>
#include "constant.hpp"
#include "monster.hpp"

void getInfo(){
	std::cout << "ID : " << global::id << std::endl;
	std::cout << "project : " << global::project << std::endl;
	std::cout << "description : " << global::desc << std::endl;
}

int main(){
	getInfo();

	int vague1[10];

	genZmb(vague1, 10);
	printZmb(vague1, 10);

	int vague2[20];

	return 0;
}
