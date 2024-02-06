# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "ghostbasil"
version = v"0.0.14"

# Collection of sources required to complete build
sources = [
    GitSource("https://github.com/biona001/ghostbasil.git", "50aef6a0f7810b2a8a41e6ee36079950fcf54313")
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

make
make install

# install license
install_license $WORKSPACE/srcdir/ghostbasil/R/LICENSE.md
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
julia_versions = [
    v"1.8.0", v"1.8.1", v"1.8.2", v"1.8.3", v"1.8.4", v"1.8.5",
    v"1.9.0", v"1.9.1", v"1.9.2", v"1.9.3", v"1.9.4", 
    v"1.10.0"
]
working_platforms = [ # ghostbasil won't work on windows, and currently fails on mac
    Platform("x86_64", "linux"; libc = "glibc"),
    Platform("aarch64", "linux"; libc = "glibc"),
    Platform("powerpc64le", "linux"; libc = "glibc"),
    Platform("x86_64", "linux"; libc = "musl"),
    Platform("aarch64", "linux"; libc = "musl"),
]

# expand platforms to specify julia version explicitly
# see https://github.com/JuliaInterop/CxxWrap.jl/issues/395
platforms = Platform[]
for p in working_platforms, julia_version in julia_versions
    p["julia_version"] = string(julia_version)
    push!(platforms, deepcopy(p))
end
platforms = expand_cxxstring_abis(platforms)

# The products that we will ensure are always built
products = [
    LibraryProduct("libghostbasil_wrap", :libghostbasil_wrap)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    Dependency("libcxxwrap_julia_jll"; compat = "0.11.2"),
    BuildDependency("Eigen_jll"),
    BuildDependency("libjulia_jll")
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, 
    dependencies; julia_compat="1.9", preferred_gcc_version = v"7.1.0")
