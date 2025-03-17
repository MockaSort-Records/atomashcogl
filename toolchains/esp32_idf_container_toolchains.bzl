def _containerized_toolchain_impl(ctx):
    return [platform_common.ToolchainInfo(
        image = ctx.attr.image,
        command = ctx.file.tool,
    )]

containerized_toolchain = rule(
    implementation = _containerized_toolchain_impl,
    attrs = {
        "image": attr.string(mandatory = True),
        "tool": attr.label(
            allow_single_file = True,
            mandatory = True,
            executable = True,
            cfg = "host",
        ),
    },
)
