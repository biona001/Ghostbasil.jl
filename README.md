# Ghostbasil.jl

[![Build Status](https://github.com/biona001/GhostBASIL.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/biona001/GhostBASIL.jl/actions/workflows/CI.yml?query=branch%3Amain)

:warning: **This package requires Julia v1.10 or newer** and a matching
`ghostbasil_jll` artifact. The current BinaryBuilder recipe targets Linux
(`x86_64`, `aarch64`, and `powerpc64le`) and macOS (`x86_64` and `aarch64`) for
Julia 1.10 through 1.14.

This is an experimental package that provides a Julia wrapper to the C++ code of [ghostbasil](https://github.com/JamesYang007/ghostbasil) package. Interfacing is accomplished by [CxxWrap.jl](https://github.com/JuliaInterop/CxxWrap.jl). 

## Usage

**We do not encourage using this package yet**. `ghostbasil.jl` currently exports only a single function, and it is intentionally left undocumented. Eventually we will make `ghostbasil.jl`'s usage similar to the R package equivalent by exposing a number of matrix classes and the general ghostbasil function. 
