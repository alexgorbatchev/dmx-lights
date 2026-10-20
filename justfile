mod ofl 'tools/ofl/justfile'

default:
    @just --list --list-submodules

# Prepare dependencies for local development.
setup:
    just ofl setup
