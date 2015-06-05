Important notice on copyright
------------------------------------------------------------------------

Author of all popcnt-related code is Wojciech Muła.
See https://github.com/WojciechMula/sse-popcount

This (modified) code differs only in benchmarking methods and compiler support

========================================================================
                           SIMD popcount
========================================================================

Sample programs for article: http://0x80.pl/articles/sse-popcount.html

Introduction
------------------------------------------------------------------------

Subdirectory **original** contains code from 2008 --- it is 32-bit
and GCC-centric. The **root directory** contains fresh C++11 code,
written with intrinsics and tested on 64-bit machine.

As usual type ``make`` to compile programs, then you can invoke:

* ``verify`` --- program tests if all non-lookup implementations counts
  bits properly.
* ``speed`` --- program tests different implementations of popcount
  procedure; please read help to find all options (run the program
  without arguments).

You can also run ``make run`` to run ``speed`` for all available
implementations.

Testing architectures, compilers and compiler options
------------------------------------------------------------------------

``make_all.sh`` script can be used to test against different compilers,
architectures and optimization flags. It needs to be configured: in the
beginning of ``make_all.sh`` you will find arrays ``COMPILERS`` and
``COMPILER_NAMES`` which must be modified according to compilers installed
in your system.

After invocation this script will create ``results`` directory, which will
contain (for each triple "compiler-architecture-optimization flag"):
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
* ``bit-parallel-optimized`` --- in this variant counting
  on packed bytes is performed exactly in the same way
  as described in the article: this gives **50% speedup**.
* ``sse-bit-parallel`` --- SSE implementation of
  ``bit-parallel-optimized``
* ``builtin32`` --- Compiler-provided built-in function (works with 32-bit dwords)
* ``builtin64`` --- Same as above, but 64-bit qwords
* ``cpu`` --- Intrinsic function for CPU instruction (same builtin64, when available)

