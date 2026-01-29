cmake_minimum_required(VERSION 3.5)

project(my-project LANGUAGES C)

find_package(SCIP REQUIRED)

add_executable(my-project main.c)

target_link_libraries(my-project PRIVATE ${SCIP_LIBRARIES})

target_include_directories(my-project PRIVATE ${SCIP_INCLUDE_DIRS})

install(TARGETS my-project)
