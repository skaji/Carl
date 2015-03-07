package Carl::Indexer;
use strict;
use warnings;
use Config;
use File::Find 'find';
use JSON::PP;
use List::Util 'sum';
use Carl;

our $VERSION = $Carl::VERSION;

sub new {
    my ($class, %option) = @_;
    my $directory = delete $option{directory} or die;
    bless { %option, directory => $directory }, $class;
}

# header is copied from Carmel::App::write_index
sub _write_index {
    my ($self, $fh, @distribution) = @_;

    my $count = sum(0, map { scalar(@{$_->{package}}) } @distribution) + 1;

    print $fh <<EOF;
File:         02packages.details.txt
URL:          http://www.perl.com/CPAN/modules/02packages.details.txt
Description:  Package names found in local directories
Columns:      package name, version, path
Intended-For: Automated fetch routines, namespace documentation.
Written-By:   @{[ sprintf "%s %s", __PACKAGE__, __PACKAGE__->VERSION ]}
Line-Count:   $count

EOF

    for my $dist (@distribution) {
        my $pathname = $dist->{pathname};
        for my $package (@{ $dist->{package} }) {
            printf $fh "%-36s %-8s %s\n",
                $package->{name}, $package->{version} // 'undef', $pathname;
        }
    }
}

sub write_index {
    my ($self, $fh) = @_;
    my @install_json = $self->gather_install_json;
    my @distribution;
    for my $json (@install_json) {
        my $meta = decode_json do { local (@ARGV, $/) = $json; <> };
        push @distribution, {
            pathname => $meta->{pathname},
            package => [
                map +{
                    name => $_,
                    version => $meta->{provides}{$_}{version},
                }, sort keys %{$meta->{provides}}
            ],
        };
    }
    $self->_write_index($fh, @distribution);
}

sub gather_install_json {
    my $self = shift;
    my @install_json;
    find sub {
        return unless -f $_ && $_ eq "install.json";
        push @install_json, $File::Find::name;
    }, $self->{directory};
    sort @install_json;
}

1;
