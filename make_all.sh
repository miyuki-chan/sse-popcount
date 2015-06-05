#!/bin/bash -e
COMPILERS=('clang++' '/opt/gcc-6.0.0/bin/g++')
COMPILER_NAMES=(Clang GCC)
ARCHS=('-mssse3' '-msse4' '-march=native')
ARCH_NAMES=(ssse3 sse4 native)

dest_dir="$(dirname "${0}")/results"
rm -rf "${dest_dir}"
mkdir -p "${dest_dir}"

for ((i = 0; i < ${#COMPILERS[@]}; i++ ))
do
    compiler=${COMPILERS[$i]}
    comp_name=${COMPILER_NAMES[$i]}
    if [[ ${comp_name} == 'GCC' ]]; then
        have_popcnt=1
        dump=tree-dump
    else
        have_popcnt=0
        dump=speed.ll
    fi
    echo "=== Compiler: ${comp_name} ==="
    ${compiler} -v
    echo '================'

    for ((j = 0; j < ${#ARCHS[@]}; j++ ))
    do
        arch=${ARCHS[$j]}
        arch_name=${ARCH_NAMES[$j]}
        echo "=== Architecture: ${arch_name} ==="
        for opt in 'O2' 'O3'
        do
            echo "<<< Optimization level: ${opt} >>>"
            make clean

            # Build speed binary and measure build time
            time make CXX="${compiler}" ARCH_FLAGS=${arch} HAVE_POPCNT_INSTRUCTION=${have_popcnt} \
                                        OPT_FLAGS="-${opt}" speed

            # Generate assembly file and IR dump
            make CXX="${compiler}" ARCH_FLAGS=${arch} HAVE_POPCNT_INSTRUCTION=${have_popcnt} \
                                        OPT_FLAGS="-${opt}" speed.s ${dump}
            mv speed.s "${dest_dir}/speed-${comp_name}-${arch_name}-${opt}.s"
            if [[ ${comp_name} == 'GCC' ]]; then
                mv speed.cpp.100t.optimized "${dest_dir}/speed-${arch_name}-${opt}.cpp.100t.optimized"
            else
                mv speed.ll "${dest_dir}/speed-${arch_name}-${opt}.ll"
            fi

            # Run the benchmark
            make run | tee "${dest_dir}/result-${comp_name}-${arch_name}-${opt}.txt"
        done
    done
done
