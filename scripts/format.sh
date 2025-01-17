#!/usr/bin/env bash
# Code formatter.
set -eufo pipefail

section() {
    echo "- $*" >&2
}

GOOGLE_JAVA_FORMAT="$(bazel run --run_under=echo //scripts:google-java-format)"

section "Buildifier"
echo "    buildifier" >&2
bazel run //:buildifier

section "Java"
echo "    google-java-format" >&2
find "$PWD/java" -type f -name '*.java' | xargs "$GOOGLE_JAVA_FORMAT" --replace

section "Ruby"
echo "    rubocop" >&2
bazel run //rb:lint

section "Rust"
echo "   rustfmt" >&2
bazel run @rules_rust//:rustfmt

section "Copyright"
bazel run //scripts:update_copyright
