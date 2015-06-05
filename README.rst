========================================================================
                           SIMD popcount
========================================================================

Important notice on copyright
------------------------------------------------------------------------
Author of all popcnt-related code is Wojciech Muła.

Original repo: https://github.com/WojciechMula/sse-popcount

Sample programs for article: http://0x80.pl/articles/sse-popcount.html

This (modified) code differs only in benchmarking methods and compiler
support it also contains code for benchmarking compiler built-in functions

Introduction
------------------------------------------------------------------------
As usual type ``make`` to compile programs, then you can invoke:

* ``verify`` --- program tests if all non-lookup implementations counts
  bits properly.
* ``speed`` --- program tests different implementations of popcount
  procedure; please read help to find all options (run the program
  without arguments).

You can also run ``make run`` to run ``speed`` for all available
implementations.

Additional Makefile options and targets
------------------------------------------------------------------------
Makefile allows to set the following variables:

* ``CXX`` --- path to C++ compiler binary (by default, uses system GCC compiler, ``g++``)
* ``HAVE_POPCNT_INSTRUCTION`` --- when set to 0, popcnt intrinsic is disabled
* ``ARCH_FLAGS`` --- flags controlling target architecture (by default ``-march=native``)
* ``OPT_FLAGS`` --- flags controlling optimization (by default ``-O2``)

There are also some additional targets:

* ``speed.s`` --- produces assembly code
* ``tree-dump`` --- produces GIMPLE dump before expansion pass (works only with GCC)
* ``speed.ll`` --- produces LLVM intermediate representation (works only with Clang)

Testing architectures, compilers and compiler options
------------------------------------------------------------------------
``make_all.sh`` script can be used to test against different compilers,
architectures and optimization flags. It needs to be configured: in the
beginning of ``make_all.sh`` you will find arrays ``COMPILERS`` and
``COMPILER_NAMES`` which must be modified according to compilers installed
in your system.

After invocation this script will create ``results`` directory, which will
contain (for each triple "compiler -- architecture -- optimization flags"):

* ``speed-*.s`` --- annotated assembly code
* ``speed-*.cpp.100t.optimized`` --- dump of final GIMPLE IR (for GCC only)
* ``speed-*.ll`` --- dump of LLVM IR (for Clang only)
* ``results-*.txt`` --- benchmark results

Available implementations in this version
------------------------------------------------------------------------
There are following procedures:

* ``sse-lookup`` --- pshufb version described in the article.
* ``lookup-8`` --- lookup table of type ``std::uint8_t[256]``.
* ``lookup-64`` --- lookup table of type ``std::uint64_t[256]``,
  LUT is 8 times larger, but we avoid extending 8 to 64 bits.
* ``bit-parallel`` --- well know bit parallel method.
* ``bit-parallel-optimized`` --- in this variant counting on packed bytes is performed as described in the article.
* ``sse-bit-parallel`` --- SSE implementation of ``bit-parallel-optimized``
* ``builtin32`` --- Compiler-provided built-in function (works with 32-bit dwords)
* ``builtin64`` --- Same as above, but 64-bit qwords
* ``cpu`` --- Intrinsic function for CPU instruction (same as builtin64, when available)

*Note:* popcnt intrinsic is disabled for Clang by default (because the corresponding instrinsic is not supported),
but one can see that it is used in builtin64 for sse4 and higher ISA's.
