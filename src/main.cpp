#include <iostream>
#include "constant.hpp"
#include "monster.hpp"
#include "sub.hpp"
#include "lib.hpp"

void getInfo(){
	std::cout << std::endl;
	std::cout << "Information general du projet :" << std::endl;
	std::cout << "ID : " << global::id << std::endl;
	std::cout << "project : " << global::project << std::endl;
	std::cout << "description : " << global::desc << std::endl;
	std::cout << std::endl;
}

int main(int argc, char** argv){

	#ifdef HW
	std::cout << "Hello World!" << std::endl;
	#endif
	#ifdef PI
	std::cout << "2" << PI << "²" << std::endl;
	#endif

   for(int i=1; i<argc; ++i){
      std::cout << argv[i] << std::endl;
   }

   libibi();

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
