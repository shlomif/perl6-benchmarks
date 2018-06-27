#! /usr/bin/env perl
#
# Short description for benchmark.pl
#
# Author Shlomi Fish <shlomif@cpan.org>
# Version 0.1
# Copyright (C) 2018 Shlomi Fish <shlomif@cpan.org>
# Modified On 2018-06-13 20:27
# Created  2018-06-13 20:27
#
use strict;
use warnings;

use Benchmark qw/ timethese /;
use Cwd qw/ getcwd /;

my $PWD = getcwd;

sub _bench
{
    my ( $DIR, $TESTS ) = @_;

    chdir($DIR);
    timethese( 1, $TESTS, );
    chdir($PWD);

    return;
}
_bench(
    "./process-0freecells-log/",
    {
        'cpy3' =>
            sub { system( "python3", "compress-summary-fc-solve-log.py" ); },
        'pypy' => sub { system( "pypy", "compress-summary-fc-solve-log.py" ); },
        'p6' => sub { system( "perl6", "compress-summary-fc-solve-log.p6" ); },
    }
);

_bench(
    "./euler189/",
    {
        'p5' => sub { system( $^X,     "euler_189-2.pl" ); },
        'p6' => sub { system( "perl6", "euler_189-2.p6" ); },
    }
);
_bench(
    "./euler287/",
    {
        'cpy3' => sub { system( "python3", "euler_287_v1.py" ); },
        'pypy' => sub { system( "pypy",    "euler_287_v1.py" ); },
        'p6'   => sub { system( "perl6",   "euler_287_v1.p6" ); },
    }
);

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
