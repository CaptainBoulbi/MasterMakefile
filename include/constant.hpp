#ifndef CONSTANT_HPP
#define CONSTANT_HPP

namespace global{
	inline double id = 6.9;
	inline std::string_view project = "makefileTest";
	inline std::string_view desc = "petit programme en c++ pour tester les fihciers Makefile";
}

inline int genID(){
	static int s_id_gen = 0;
	return ++s_id_gen;
}

#endif //CONSTATN_HPP
