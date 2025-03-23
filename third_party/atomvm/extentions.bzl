## repositories.bzl
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def atomvm_git():
    git_repository(
        name = "atomvm",
        remote = "https://github.com/atomvm/AtomVM.git",
        commit = "388940d562d16a80d6705a7ddbdf299a46e7147a",
        build_file = "third_party/atomvm/BUILD.atomvm",
    )

def _atomvm_impl(_ctx):
    atomvm_git()

atomvm = module_extension(
    implementation = _atomvm_impl,
)
