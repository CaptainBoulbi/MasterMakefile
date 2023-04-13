#include <iostream>
#include "constant.hpp"

void genZmb(int* zmb, int n){
	for (int i = 0; i<n; i++){
		*(zmb+i) = genID();
	}
}

void printZmb(int* zmb, int n){
	for (int i = n; i>=0; i--){
		std::cout << *(zmb+i) << std::endl;
	}
}
