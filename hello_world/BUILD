# load("@rules_oci//oci:defs.bzl", "oci_image")
load("@//:esp32_rules/esp32.bzl","esp32_component")
package(default_visibility = ["//visibility:public"])

esp32_component(
    name = "hello_world",
    srcs = ["main/hello.c", "main/CMakeLists.txt", "CMakeLists.txt"],
)
