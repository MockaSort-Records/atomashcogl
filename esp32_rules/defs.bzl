ESP32_PROJECT_CMAKE_TPL = """
# ----autogenerated-----
cmake_minimum_required(VERSION 3.16)

include($ENV{IDF_PATH}/tools/cmake/project.cmake)
# to be removed 
idf_build_set_property(MINIMAL_BUILD ON)
project({{PROJECT_LABEL}})
"""
