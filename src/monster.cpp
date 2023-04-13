#include <iostream>
#include "constant.hpp"

void genZmb(int* zmb, int n){
	for (int i = 0; i<n; i++){
		*(zmb+i) = genID();
	}
}

void printZmb(int* zmb, int n){
	for (int i = n-1; i>=0; i--){
		std::cout << *(zmb+i) << '\t';
		if (!(i%5)){ std::cout << std::endl; }
	}
	std::cout << std::endl;
}
