load("@//:esp32_rules/esp32.bzl","esp32_application")
package(default_visibility = ["//visibility:public"])

esp32_application(
    name = "hello_world",
    srcs = ["main/hello.c", "main/CMakeLists.txt", "CMakeLists.txt"],
)
