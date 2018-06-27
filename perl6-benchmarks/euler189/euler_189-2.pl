#!/usr/bin/perl

use strict;
use warnings;

use bytes;
use integer;

use feature qw/say/;

my %colors = (
    '00' => [ 1, 2 ],
    '11' => [ 0, 2 ],
    '22' => [ 0, 1 ],
    '01' => [2],
    '10' => [2],
    '02' => [1],
    '20' => [1],
    '12' => [0],
    '21' => [0],
);

my @l_colors = ( [ 1, 2 ], [ 0, 2 ], [ 0, 1 ] );

sub my_find
{
    my ($wanted_h) = @_;

    # The start_data for $h == 1
    my $data = {
        seq     => { '0' => 1, '1' => 1, '2' => 1, },
        derived => {
            '' => {
                '0' => 1,
                '1' => 1,
                '2' => 1,
            }
        },
        count => 3,
    };
    for my $h ( 1 .. $wanted_h - 1 )
    {
        my $this_seqs     = $data->{seq};
        my $prev_deriveds = $data->{derived};

        my $total_count   = 0;
        my $next_deriveds = {};
        my $next_seqs     = {};

        while ( my ( $seq, $seq_count ) = each %$this_seqs )
        {
            while ( my ( $left, $left_count ) =
                each %{ $prev_deriveds->{ substr( $seq, 0, -1 ) } // {} } )
            {
                my $delta = $seq_count * $left_count;
                foreach my $lefter_tri_color (
                    @{ $colors{ substr( $seq, -1 ) . substr( $left, -1 ) } } )
                {
                    foreach
                        my $leftest_color ( @{ $l_colors[$lefter_tri_color] } )
                    {
                        my $str = $left . $leftest_color;

                        $total_count                 += $delta;
                        $next_seqs->{$str}           += $delta;
                        $next_deriveds->{$seq}{$str} += $left_count;
                    }
                }
            }
        }

        # Fill the next data.
        $data = {
            seq     => $next_seqs,
            derived => $next_deriveds,
            count   => $total_count,
        };
        say "Count[@{[$h+1]}] = $total_count";
    }

    return $data->{count};
}

# Test
{
    say my_find(2), " should be 3*2*2*2 == 24";
}
say "Result[8] = ", my_find(8);

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
