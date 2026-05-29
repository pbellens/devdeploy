#!/usr/bin/env bash
# strip_compiler_wrappers.sh
#
# Reads compile_commands.json (from stdin or first argument), strips any
# leading compiler-wrapper and/or cache tool tokens from each "command"
# field, and writes the updated JSON to stdout.
#
# Tokens are stripped from the front as long as they match one of:
#   - a compiler-wrapper   (path contains "compiler-wrapper")
#   - a cache front-end    (basename is ccache, distcc, or sccache)

INPUT="${1:-compile_commands.json}"

jq '
  # Helper: true if a single token should be stripped
  def is_wrapper_or_cache:
    test("compiler-wrapper"; "i")          # any compiler-wrapper path
    or (split("/")[-1] | test("^(ccache|distcc|sccache)$"; "i"));  # cache tools

  # Strip leading wrapper/cache tokens from a command string
  def strip_prefix:
    split(" ")                             # tokenise
    | map(select(length > 0))             # drop empty strings from multiple spaces
    | until(
        length == 0 or (.[0] | is_wrapper_or_cache | not);
        .[1:]                              # drop the first token and retry
      )
    | join(" ");                           # reassemble

  map(.command |= strip_prefix)
' "$INPUT"

