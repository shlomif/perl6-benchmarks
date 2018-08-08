#! /bin/bash
#
# driver.bash
# Copyright (C) 2018 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#

(
    set -x
    perl6 --version
    make run
) 2>&1 | tee -a results.txt

