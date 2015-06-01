size=1000000
iter=5000
names="cpu builtin32 builtin64 sse-lookup sse-bit-parallel bit-parallel-optimized bit-parallel lookup-8 lookup-64"
# binaries_speed32="speed-32-o2 speed-32-o3"
binaries_speed="speed-O2 speed-O3"
if [[ "$1" = "speed" ]]; then
    binaries=$binaries_speed
else
    binaries="$1"
fi

for bin in $binaries
do
    case "$bin" in
        speed-32*)
            echo -n "32-bit "
            ;;
        *)
            echo -n "64-bit "
            ;;
    esac
    case "$bin" in
        *-O2)
            echo "-O2"
            ;;
        *-O3)
            echo "-O3"
            ;;
    esac
    for name in $names
    do
        ./$bin $name $size $iter
    done
done
