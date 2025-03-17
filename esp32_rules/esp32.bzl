def _esp32_application_impl(ctx):

    toolchain = ctx.toolchains["@//toolchains:conteinerized_toolchain_type"]
    out_folder = ctx.attr.name + "_image"
    application_img = ctx.actions.declare_file(out_folder +"/"+ctx.attr.name + ".bin")
    partition_img = ctx.actions.declare_file(out_folder +"/partition-table.bin")
    bootloader_img = ctx.actions.declare_file(out_folder +"/bootloader.bin")
    flasher_args = ctx.actions.declare_file(out_folder +"/flasher_args.json")
    bin_path="{bin}/{pkg_name}/{dest}".format(bin=ctx.bin_dir.path,pkg_name=ctx.attr.name,dest=out_folder)
    args =" {}".format(ctx.attr.name)
    args +=" {}".format(toolchain.image)
    args +=" {}".format(bin_path)
    for file in ctx.files.srcs:
        args += " {}".format(file.path)

    ctx.actions.run_shell(
        command = "./{script} {arguments}".format(script=toolchain.command.path, arguments=args),
        inputs = ctx.files.srcs,
        outputs = [application_img, partition_img, bootloader_img, flasher_args],
        tools = [toolchain.command]
    )
    
    return [DefaultInfo(files = depset([application_img, partition_img, bootloader_img, flasher_args]))]
  
esp32_application = rule(
    implementation = _esp32_application_impl,
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