# ghostbasil

[![Build Status](https://github.com/biona001/GhostBASIL.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/biona001/GhostBASIL.jl/actions/workflows/CI.yml?query=branch%3Amain)

:warning: **This package currently only works on Julia v1.9.0 or v1.9.3** with Linux aarch64 or x86_64. Note Julia version **must** be v1.9.0 or v1.9.3. 

This is an experimental package that provides a Julia wrapper to the C++ code of [ghostbasil](https://github.com/JamesYang007/ghostbasil) package. Interfacing is accomplished by [CxxWrap.jl](https://github.com/JuliaInterop/CxxWrap.jl). 

## Usage

**We do not encourage using this package yet**. `ghostbasil.jl` currently exports only a single function, and it is intentionally left undocumented. Eventually we will make `ghostbasil.jl`'s usage similar to the R package equivalent by exposing a number of matrix classes and the general ghostbasil function. 
