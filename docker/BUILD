load("@aspect_bazel_lib//lib:expand_template.bzl", "expand_template")
load("@rules_oci//oci:defs.bzl", "oci_image", "oci_load", "oci_push")
load(":defs.bzl", "atomvm_layer")

oci_image(
    name = "atomvm_env",
    base = "@idf_image_linux_amd64",
    entrypoint = [
        "/bin/bash",
        "-c",
        "/opt/esp/entrypoint.sh idf.py -B /build build",
    ],
    tars = [atomvm_layer()],
    workdir = "/atomvm/src/platforms/esp32",
)

oci_push(
    name = "atomvm_env_push",
    image = ":atomvm_env",
    remote_tags = ":image_tag",
    repository = "index.docker.io/bearpawangelo/mockasort-records",
)

expand_template(
    name = "image_tag",
    out = "image_tag.txt",
    stamp = 1,
    substitutions = {
        "{STABLE_GIT_COMMIT}": "{{STABLE_GIT_COMMIT}}",
    },
    template = ["""atomvm_env_image:{STABLE_GIT_COMMIT}"""],
)

oci_load(
    name = "atomvm_env_load",
    image = ":atomvm_env",
    repo_tags = ":image_tag",
)
