package Carl::Indexer;
use strict;
use warnings;
use Config;
use File::Find 'find';
use JSON::PP;
use List::Util 'sum';
use Carl;
use Perl::PrereqDistributionGatherer;

sub new {
    my ($class, %option) = @_;
    my $directory = delete $option{directory} or die;
    my $cpanfile  = delete $option{cpanfile}  or die;
    bless { %option, cpanfile => $cpanfile, directory => $directory }, $class;
}

# header is copied from Carmel::App::write_index
sub write_index {
    my ($self, $fh) = @_;
    my ($distribution, $miss) = $self->gather;
    if (@$miss) {
        warn "\e[31mMissing $_ in $self->{directory} directory\e[m\n" for @$miss;
    }

    my $count = sum(0, map {
        scalar(keys %{$_->install_json_hash->{provides}})
    } @$distribution) + 1;

    print $fh <<EOF;
File:         02packages.details.txt
URL:          http://www.perl.com/CPAN/modules/02packages.details.txt
Description:  Package names found in local directories
Columns:      package name, version, path
Intended-For: Automated fetch routines, namespace documentation.
Written-By:   @{[ sprintf "Carl %s", , Carl->VERSION ]}
Line-Count:   $count

EOF

    for my $dist (@$distribution) {
        my $pathname = $dist->pathname;
        my $provides = $dist->install_json_hash->{provides};
        for my $package (sort keys %$provides) {
            printf $fh "%-36s %-8s %s\n",
                $package, $provides->{$package}{version} // 'undef', $pathname;
        }
    }
}

sub gather {
    my $self = shift;
    my $gatherer = Perl::PrereqDistributionGatherer->new;
    my ($dist, $core, $miss) = $gatherer->gather_from_cpanfile(
        $self->{cpanfile}, inc => [
            "$self->{directory}/$Config{archname}",
            $self->{directory},
            @Config{qw(privlibexp archlibexp)},
        ],
    );
    ($dist, $miss);
}

1;
