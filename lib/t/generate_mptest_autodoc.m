function generate_mptest_autodoc(install_dir)
% generate_mptest_autodoc - Generate the stubs and symlinks for Ref Manual.
% ::
%
%   generate_matpower_autodoc(install_dir)
%
% Inputs:
%   install_dir (char array) : path to the install directory for the package
%
% Creates the .rst stubs and symlinks to the source files for all functions
% and classes to be included in the Reference Manual. Creates all of the
% inputs (lists of functions and classes) to pass to generate_autodoc_stubs
% and generate_source_symlinks.

%   MP-Test
%   Copyright (c) 2023-2024, Power Systems Engineering Research Center (PSERC)
%   by Ray Zimmerman, PSERC Cornell
%
%   This file is part of MATPOWER.
%   Covered by the 3-clause BSD License (see LICENSE file for details).
%   See https://matpower.org for more info.

if nargin < 1
    matpower_dir = '~/dev/projects/mptest/';
end

sphinx_src_dir = [matpower_dir 'docs/sphinx/source/'];

lib_fcns = {
    'have_feature_matlab', ...
    'have_feature_octave', ...
    'have_feature', ...
    'mptestver', ...
    't_begin', ...
    't_end', ...
    't_file_match', ...
    't_is', ...
    't_ok', ...
    't_run_tests', ...
    't_skip', ...
    't_str_match', ...
};
lib_t_fcns = {
    'test_mptest', ...
    't_have_feature', ...
    't_test_fcns', ...
};
%     'generate_mptest_autodoc', ...


in = struct(...
    'function', struct(...
        'destdir', 'functions', ...
        'list', struct(...
            'mod', {'mptest', 'mptest'}, ...
            'src_path', {'lib', 'lib/t'}, ...
            'names', {lib_fcns, lib_t_fcns} ...
        ) ...
    ) ...
);

%% create stubs and symlinks for reference manual
generate_autodoc_stubs(in, sphinx_src_dir);
generate_source_symlinks(in, [sphinx_src_dir 'matlab-source/'], '../../../../../');
