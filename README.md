MP-Test
=======

MP-Test is a set of functions for implementing unit testing in MATLAB or
Octave. It was initially developed for [MATPOWER][1], and is used by
[MATPOWER][1], [MATPOWER Interior Point Solver (MIPS)][2], [MP-Opt-Model][7]
and [MATPOWER Optimal Scheduling Tool (MOST)][3]. It also includes a
function `have_feature()` for detecting support for optional functionality.

Installation
------------

**Note to [MATPOWER][1] users:** _MP-Test is included when you install
[MATPOWER][1]. There is generally no need to install it separately. You
can skip directly to step 3 to verify._

Installation and use of MP-Test requires familiarity with the basic operation
of MATLAB or Octave, including setting up your MATLAB path.

1.  Clone the repository or download and extract the zip file of the MP-Test
    distribution from the [MP-Test project page][4] to the location of your
    choice. The files in the resulting `mptest` or `mptestXXX` directory,
    where `XXX` depends on the version of MP-Test, should not need to be
    modified, so it is recommended that they be kept separate from your
    own code. We will use `<MPTEST>` to denote the path to this directory.

2.  Add the following directories to your MATLAB/Octave path:
    *   `<MPTEST>/lib`
    *   `<MPTEST>/lib/t`

3.  At the MATLAB prompt, type `test_mptest` to run the test suite and
    verify that MP-Test is properly installed and functioning. The result
    should resemble the following:
```matlab
  >> test_mptest
  t_test_fcns.......ok
  t_have_feature....ok
  All tests successful (25 of 25)
  Elapsed time 0.07 seconds.
```

Usage
-----

*   Write test functions of the following form, where `t_ok` and `t_is` are
    used to test for specific conditions or matches, respectively.
```matlab
  function mptest_ex1(quiet)
  if nargin < 1
      quiet = 0;
  end
  t_begin(4, quiet);
  t_ok(pi > 3, 'size of pi');
  if have_feature('octave')
      t_ok(1, 'Octave-only test foo');
      t_ok(1, 'Octave-only test bar');
  else
      t_skip(2, 'foo and bar tests require Octave');
  end
  t_is(2+2, 4, 12, '2+2 still equals 4');
  t_end;
```

*   Then run your test function:
```
  >> mptest_ex1
  1..4
  ok 1 - size of pi
  skipped 2..3 - foo and bar tests require Octave
  ok 4 - 2+2 still equals 4
  All tests successful (2 passed, 2 skipped of 4)
  Elapsed time 0.00 seconds.
```

*   If you have several test functions, create a function to run them all as follows:
```matlab
  function test_everything_ex1(verbose)
  if nargin < 1
    verbose = 0;
  end
  tests = {};
  tests{end+1} = 'mptest_ex1';
  tests{end+1} = 't_test_fcns';

  t_run_tests( tests, verbose );
```

*   Run all of your tests at once. The output may look something like:
```
  >> test_everything_ex1
  mptest_ex1.....ok (2 of 4 skipped)
  t_test_fcns....ok
  All tests successful (7 passed, 2 skipped of 9)
  Elapsed time 0.00 seconds.
```

Documentation
-------------

The primary sources of documentation for MP-Test are this section of
this README file and the built-in `help` command. As with the built-in
functions and toolbox routines in MATLAB and Octave, you can type `help`
followed by the name of a command or M-file to get help on that
particular function.

#### Testing Functions

- __t_begin__ -- begin running tests

  ```
  t_begin(num_of_tests, quiet)
  ```
  Initializes the global test counters, setting everything up to execute
  `num_of_tests` tests using `t_ok` and `t_is`. If `quiet` is true, it
  will not print anything for the individual tests, only a summary when
  `t_end` is called.

- __t_end__ -- finish running tests and print statistics
  ```
  t_end
  ```
  Checks the global counters that were updated by calls to `t_ok`,
  `t_is` and `t_skip` and prints out a summary of the test results.

- __t_ok__ -- test whether a condition is true
  ```
  ok = t_ok(expr, msg)
  ```
  Increments the global test count and if the `expr` is true it
  increments the passed tests count, otherwise increments the failed
  tests count. Prints `'ok'` or `'not ok'` followed by the `msg`, unless
  `t_begin` was called with input `quiet` equal true. Intended to be
  called between calls to `t_begin` and `t_end`.

- __t_is__ -- test if two (scalar, vector, matrix) values are identical,
  to some tolerance
  ```
  t_is(got, expected, prec, msg)
  ```
  Increments the global test count and if the maximum difference between
  corresponding elements of `got` and `expected` is less than
  10^(-`prec`) then it increments the passed tests count, otherwise
  increments the failed tests count. Prints `'ok'` or `'not ok'`
  followed by the `msg`, unless `t_begin` was called with input `quiet`
  equal true. The input values can be real or complex, and they can be
  scalar, vector, or 2-d or higher matrices. If `got` is a vector or
  matrix and `expected` is a scalar or `NaN`, all elements must match
  the scalar. Intended to be called between calls to `t_begin` and
  `t_end`.

  Optionally returns a true or false value indicating whether or not the
  test succeeded. `NaN` values are considered to be equal to each other.

- __t_skip__ -- skip a number of tests
  ```
  t_skip(cnt, msg)
  ```
  Increments the global test count and skipped tests count. Prints
  `'skipped tests x..y : '` followed by the `msg`, unless `t_begin` was
  called with input `quiet` equal true. Intended to be called between
  calls to `t_begin` and `t_end`.

- __t_run_tests__ -- run a series of tests
  ```
  all_ok = t_run_tests(test_names, verbose)
  ```
  Runs a set of tests whose names are given in the cell array `test_names`.
  If the optional parameter `verbose` is true, it prints the details of the
  individual tests. Optionally returns an `all_ok` flag, equal to 1 if all
  tests pass (and the number matches the expected number), 0 otherwise.

#### Other Functions

- __have_feature__ -- test for optional functionality, with version information
  ```
  TorF = have_feature(tag)
  TorF = have_feature(tag, toggle)
  ver_str = have_feature(tag, 'vstr')
  ver_num = have_feature(tag, 'vnum')
  date    = have_feature(tag, 'date')
  info    = have_feature(tag, 'all')
  have_feature(tag, 'clear_cache')
  have_feature('all', 'clear_cache')
  ```
  Returns the availability version and release information for optional
  functionality. All information is cached, and the cached values
  returned on subsequent calls. If the functionality exists, an attempt
  is made to determine the release date and version number. The second
  argument defines which value is returned, as follows:
  - `<none>` -- 1 = optional functionality is available, 0 = not available
  - `'vstr'` -- version number as a string (e.g. `'3.11.4'`)
  - `'vnum'` -- version number as numeric value (e.g. 3.011004)
  - `'date'` -- release date as a string (e.g. `'21-Sep-2020'`)
  - `'all'` -- struct with fields named `'av'` (for "availability"),
     `'vstr'`, `'vnum'` and `'date'`, and values corresponding to the above,
     respectively.

  For functionality that is not available, all calls with a string-valued
  second argument will return an empty value.

  Alternatively, the optional functionality specified by `tag` can be
  toggled _OFF_ or _ON_ by calling `have_feature` with a numeric second
  argument `toggle` with one of the following values:
  -  0 -- turn _OFF_ the optional functionality
  -  1 -- turn _ON_ the optional functionality (if available)
  - -1 -- toggle the _ON_/_OFF_ state of the optional functionality

  Finally, passing `'clear_cache'` as the second argument will cause the
  cached information to be cleared for the specified `tag` or, if the
  first argument is `'all'`, for all optional functionality. When
  calling with `'clear_cache'` no return value is defined.

  Examples:
  ```
  if have_feature('matlab')
      disp(['Running MATLAB version ', have_feature('matlab', 'vstr')])
  else
      disp(['Running Octave version ', have_feature('octave', 'vstr')])
  end
  ```

- __mptestver__ -- prints or returns MP-Test version info
  ```
  v = mptestver
  v = mptestver('all')
  ```
  Returns the current MP-Test version numbers. If called with an argument,
  returns a struct with the fields `Name`, `Version`, `Release` and `Date`
  (all char arrays). Calling `mptestver` without assigning the return value
  prints the version and release date of the current installation of MP-Test.


#### Private Functions

- __have_feature_matlab__ -- feature detection function for MATLAB

  Implements `'matlab'` tag for `have_feature()`.

- __have_feature_octave__ -- feature detection function for GNU Octave

  Implements `'octave'` tag for `have_feature()`.

Contributing
------------

Please see our [contributing guidelines][5] for details on how to
contribute to the project or report issues.

License
-------

MP-Test is distributed under the [3-clause BSD license][6].

----
[1]: https://github.com/MATPOWER/matpower
[2]: https://github.com/MATPOWER/mips
[3]: https://github.com/MATPOWER/most
[4]: https://github.com/MATPOWER/mptest
[5]: CONTRIBUTING.md
[6]: LICENSE
[7]: https://github.com/MATPOWER/mp-opt-model
