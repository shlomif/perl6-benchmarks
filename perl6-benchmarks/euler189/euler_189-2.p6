#!/usr/bin/perl

use v6;

=begin pod

Solution for Project Euler #189 by Shlomi Fish, L<http://www.shlomifish.org/> .

=end pod

my %colors = ('00' => ['1','2'], '11' => ['0','2'], '22' => ['0','1'],
    '01' => ['2'], '10' => ['2'],
    '02' => ['1'], '20' => ['1'],
    '12' => ['0'], '21' => ['0'],
);

my %l_colors = ('0' => ['1','2'], '1' => ['0','2'], '2' => ['0','1']);

sub my_find(Int $wanted_h) returns Int
{
    # The start_data for $h == 1
    my $this_seqs = {'0' => 1, '1' => 1, '2' => 1,};
    my $prev_deriveds =
    {
        '' =>
        {
            '0' => 1,
            '1' => 1,
            '2' => 1,
        }
    };

    my $total_count;

    for (1 ..^ $wanted_h) -> $h
    {
        $total_count = 0;
        my $next_deriveds = {};
        my $next_seqs = {};

        for $this_seqs.kv -> $seq, $seq_count
        {
            my $seq_ders = ($next_deriveds{$seq} //= {});
            for ($prev_deriveds{$seq.substr(0, *-1)}).kv -> $left, $left_count
            {
                my $delta = $seq_count * $left_count;
                # say "F = <{$seq.substr(*-1) ~ $left.substr(*-1)}>";
                for %colors{$seq.substr(*-1) ~ $left.substr(*-1)}.values -> $lefter_tri_color
                {
                    # say "Lefter = <$lefter_tri_color>";
                    for %l_colors{$lefter_tri_color}.values -> $leftest_color
                    {
                        # say "L = <$left> LEST = <$leftest_color>";
                        # say "delta = <$delta> left_count = <$left_count>";
                        my $str = $left ~ $leftest_color;

                        $total_count += $delta;
                        ($next_seqs{$str} //= 0) += $delta;
                        ($seq_ders{$str} //= 0) += $left_count;
                    }
                }
            }
        }

        # Fill the next data.
        ($this_seqs, $prev_deriveds) = ($next_seqs, $next_deriveds);
        say "Count[{$h+1}] = $total_count";
    }

    return $total_count;
}

# Test
{
    say my_find(2), " should be 3*2*2*2 == 24";
}
say "Result[8] = ", my_find(8);
