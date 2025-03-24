load("@aspect_bazel_lib//lib:tar.bzl", "mtree_mutate", "mtree_spec", "tar")

def atomvm_layer():
    mtree_spec(
        name = "atomvm_mtree",
        srcs = ["@atomvm"],
    )

    mtree_mutate(
        name = "change_dir",
        mtree = ":atomvm_mtree",
        package_dir = "atomvm",
    )

    tar(
        name = "atomvm_layer",
        srcs = ["@atomvm"],
        mtree = "change_dir",
    )

    return ":atomvm_layer"
