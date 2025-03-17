package(default_visibility = ["//visibility:public"])

constraint_setting(name = "toolchain_container_env")

constraint_value(
    name = "idf",
    constraint_setting = ":toolchain_container_env",
)

platform(
    name = "esp32",
    constraint_values = [
        ":idf",
    ],
)