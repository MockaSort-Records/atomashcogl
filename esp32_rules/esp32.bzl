def _esp32_component_impl(ctx):

    toolchain = ctx.toolchains["@//toolchains:conteinerized_toolchain_type"]
    folder = ctx.actions.declare_directory(ctx.attr.name + "_build.bin")
    
    args =" {}".format(ctx.attr.name)
    args +=" {}".format(toolchain.image)
    args +=" {}".format(folder.path)
    for file in ctx.files.srcs:
        args += " {}".format(file.path)

    ctx.actions.run_shell(
        command = "./{script} {arguments}".format(script=toolchain.command.path, arguments=args),
        inputs = ctx.files.srcs,
        outputs = [folder],
        tools = [toolchain.command]
    )
    
    return [DefaultInfo(files = depset([folder]))]
  
esp32_component = rule(
    implementation = _esp32_component_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),  # Source files
        "idf_deps": attr.string_list(default=[]),
    },
    toolchains = ["@//toolchains:conteinerized_toolchain_type"],  # Use the toolchain
)

    # target_compatible_with = select({
    #     "@platforms//os:osx": [],
    #     "@platforms//os:linux": [],
    #     "//conditions:default": ["@platforms//:incompatible"],
    # })