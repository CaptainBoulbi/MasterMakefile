#include <iostream>
#include "constant.hpp"
#include "monster.hpp"
#include "sub.hpp"

void getInfo(){
	std::cout << std::endl;
	std::cout << "Information general du projet :" << std::endl;
	std::cout << "ID : " << global::id << std::endl;
	std::cout << "project : " << global::project << std::endl;
	std::cout << "description : " << global::desc << std::endl;
	std::cout << std::endl;
}

int main(){
	printHI();

	getInfo();

	int vague1[10];

	genZmb(vague1, 10);
	printZmb(vague1, 10);

	int vague2[20];

	genZmb(vague2, 20);
	printZmb(vague2, 20);

	return 0;
}
