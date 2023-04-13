cmake_minimum_required(VERSION 3.10)

# Project
project(makefileTest LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS off)
set(CMAKE_CXX_FLAGS "-Wall -Weffc++ -Wextra -Wsign-conversion")

# Sources
file(GLOB_RECURSE SOURCES src/*.cpp)
file(GLOB_RECURSE HEADERS include/*.hpp include/*.h src/*.hpp src/*.h)

# ex librairie
# find_package(exlib REQUIRED) # ou QUIET (req = obligée, si erreur stop ; quiet = si erreur, informe et continue)
# include_directories(${exlib_INCLUDE_DIRS}) # optionnel, si erreur chercher exlibCONFIG.cmake pour trouver le $() qui convient
# link_directories(${exlib_LIB_DIRS}) # optionnel; pareil qu'en dessus
# add_definitions(${exlib_FLAGS})

# Executable
add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS})

# suite exlib
# target_link_libraries(${PROJECT_NAME} ${exlib_LIBRARIES})

# Includes
target_include_directories(${PROJECT_NAME} PUBLIC include)
target_include_directories(${PROJECT_NAME} PUBLIC src)

# tuto
# https://www.youtube.com/watch?v=9fowTjLimxQ tuto cmake
# https://www.youtube.com/watch?v=Lrt3i83wsy4 tuto cmake lib
