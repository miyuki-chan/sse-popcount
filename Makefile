CXX=g++
FLAGS=-std=c++11 -DHAVE_POPCNT_INSTRUCTION=0 -march=native -mtune=native -Wall -pedantic -Wextra
FLAGS32=$(FLAGS) -m32 -DHAVE_POPCNT_INSTRUCTION=0 -DHAVE_CVTSI128_SI64=0
FLAGS_ASM=$(FLAGS) -S -fverbose-asm -dAp

DEPS=popcnt-*.cpp config.h
ALL=speed-O2 speed-O3 verify speed-O3.s

.PHONY: all

all: $(ALL)

#speed-32-O2: $(DEPS) speed.cpp
#	$(CXX) $(FLAGS32) -O2 speed.cpp -o $@
#speed-32-O3: $(DEPS) speed.cpp
#	$(CXX) $(FLAGS32) -O3 speed.cpp -o $@
speed-O2: $(DEPS) speed.cpp
	$(CXX) $(FLAGS) -O2 speed.cpp -o $@
speed-O3: $(DEPS) speed.cpp
	$(CXX) $(FLAGS) -O3 speed.cpp -o $@

verify: $(DEPS) verify.cpp
	$(CXX) $(FLAGS) verify.cpp -o $@

speed-O2.s: $(DEPS) speed.cpp
	$(CXX) $(FLAGS_ASM) -O2 speed.cpp -o $@
speed-O3.s: $(DEPS) speed.cpp
	$(CXX) $(FLAGS_ASM) -O3 speed.cpp -o $@

run: speed
	sh run.sh speed

clean:
	rm -f $(ALL)
