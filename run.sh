size=1000000
iter=5000
names="cpu builtin32 builtin64 sse-lookup sse-bit-parallel bit-parallel-optimized bit-parallel lookup-8 lookup-64"
bin="$1"

for name in $names
do
    ./$bin $name $size $iter
done

