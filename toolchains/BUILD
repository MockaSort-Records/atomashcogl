load(":esp32_idf_container_toolchains.bzl", "containerized_toolchain")

package(default_visibility = ["//visibility:public"])

toolchain_type(
    name = "conteinerized_toolchain_type",
)

containerized_toolchain(
    name = "idf_toolchain_impl",
    image = "espressif/idf:latest",
    tool = ":build_wrapper",
)

toolchain(
    name = "idf_toolchain",
    exec_compatible_with = [
        "@//platforms:idf",
    ],
    toolchain = ":idf_toolchain_impl",
    toolchain_type = ":conteinerized_toolchain_type",
)

filegroup(
    name = "build_wrapper",
    srcs = ["build_wrapper.sh"],
    visibility = ["//visibility:private"],
)
