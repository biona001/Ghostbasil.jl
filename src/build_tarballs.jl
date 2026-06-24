# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "ghostbasil"
version = v"0.0.16"

# Collection of sources required to complete build
sources = [
    GitSource("https://github.com/biona001/ghostbasil.git", "d31c8629b4639b867a1186a33efd47341863ecf7")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
mkdir -p ghostbasil/julia/build
cd ghostbasil/julia/build

cmake \
    -DJulia_PREFIX=$prefix \
    -DCMAKE_INSTALL_PREFIX=$prefix \
    -DCMAKE_FIND_ROOT_PATH=$prefix \
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TARGET_TOOLCHAIN} \
    -DEigen3_DIR=$prefix/share/eigen3/cmake \
    -DCMAKE_BUILD_TYPE=Release \
    ../

cmake --build . --config Release --parallel ${nproc}
cmake --install .

# install license
install_license $WORKSPACE/srcdir/ghostbasil/R/LICENSE.md
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
julia_versions = [
    v"1.10.0",
    v"1.11.1",
    v"1.12.0",
    v"1.13.0",
    v"1.14.0",
]

# CxxWrap/libcxxwrap_julia_jll v0.14 only publishes cxx11 Linux
# artifacts. macOS does not use a cxxstring_abi platform tag.
working_platforms = [
    Platform("x86_64", "linux"; libc = "glibc", cxxstring_abi = "cxx11"),
    Platform("aarch64", "linux"; libc = "glibc", cxxstring_abi = "cxx11"),
    Platform("powerpc64le", "linux"; libc = "glibc", cxxstring_abi = "cxx11"),
    Platform("x86_64", "linux"; libc = "musl", cxxstring_abi = "cxx11"),
    Platform("aarch64", "linux"; libc = "musl", cxxstring_abi = "cxx11"),
    Platform("x86_64", "macos"),
    Platform("aarch64", "macos"),
]

# expand platforms to specify julia version explicitly
# see https://github.com/JuliaInterop/CxxWrap.jl/issues/395
platforms = Platform[]
for p in working_platforms, julia_version in julia_versions
    p["julia_version"] = string(julia_version)
    push!(platforms, deepcopy(p))
end

# The products that we will ensure are always built
products = [
    LibraryProduct("libghostbasil_wrap", :libghostbasil_wrap)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    Dependency("libcxxwrap_julia_jll", v"0.14.10"; compat = "0.14.10"),
    BuildDependency("Eigen_jll"),
    BuildDependency("libjulia_jll")
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, 
    dependencies; julia_compat="~1.10, ~1.11, ~1.12, ~1.13, ~1.14",
    preferred_gcc_version = v"11")
