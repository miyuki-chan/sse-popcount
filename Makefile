CXX=g++
HAVE_POPCNT_INSTRUCTION=1
ARCH_FLAGS=-march=native
OPT_FLAGS=-O2

FLAGS=-std=c++11 -DHAVE_POPCNT_INSTRUCTION=$(HAVE_POPCNT_INSTRUCTION) $(ARCH_FLAGS) -mtune=native -Wall -pedantic -Wextra
FLAGS_ASM=$(FLAGS) -S -fverbose-asm -dAp
FLAGS_LLVM=$(FLAGS) -S -emit-llvm

DEPS=popcnt-*.cpp sse_operators.cpp config.h
SPEED_SRC=speed.cpp $(DEPS)

TREE_DUMP=speed.cpp.100t.optimized
ALL=speed verify speed.s $(TREE_DUMP)

all: speed verify dumps
.PHONY: all dumps tree-dump

tree-dump: $(TREE_DUMP)
dumps: speed-asm tree-dumps

speed: $(SPEED_SRC)
	$(CXX) $(FLAGS) $(OPT_FLAGS) $< -o $@

speed.cpp.100t.optimized: $(SPEED_SRC)
	$(CXX) $(FLAGS) $(OPT_FLAGS) $< -S -o /dev/null -fdump-tree-optimized-lineno
	mv speed.cpp.*t.optimized $@

speed.ll: $(SPEED_SRC)
	$(CXX) $(FLAGS_LLVM) $(OPT_FLAGS) $< -o $@

verify: verify.cpp $(DEPS)
	$(CXX) $(FLAGS) $(OPT_FLAGS) $< -o $@

speed.s: $(SPEED_SRC)
	$(CXX) $(FLAGS_ASM) $(OPT_FLAGS) $< -o $@

# NOT YET IMPLEMENTED
# FLAGS32=$(FLAGS) -m32 -DHAVE_POPCNT_INSTRUCTION=0 -DHAVE_CVTSI128_SI64=0
# speed-32-O2: $(DEPS) speed.cpp
#	$(CXX) $(FLAGS32) -O2 speed.cpp -o $@

run: speed
	sh run.sh speed

clean:
	rm -f $(ALL)
