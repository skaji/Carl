package Carl::Builder;
use strict;
use warnings;
use Module::Metadata;

sub new {
    my ($class, %option) = @_;
    bless {%option}, $class;
}

sub install {
    my $self = shift;
    my @option;
    if (my $mirror = $self->{mirror}) {
        push @option,
            "--cascade-search",
            "--mirror" => "file://$mirror",
            "--mirror-index" => "$mirror/modules/02packages.details.txt",
            "--mirror" => "http://www.cpan.org";
    }
    $self->run_cpanm(
        @option,
        "--save-dists" => "$self->{directory}/cache",
        "-L", $self->{directory},
        "--cpanfile", $self->{cpanfile},
        "--installdeps", ".",
    ) or die "Install failed\n";
}

sub run_cpanm {
    my ($self, @argv) = @_;
    local $ENV{PERL_CPANM_OPT};
    my $fatscript = Module::Metadata->find_module_by_name("App::cpanminus::fatscript");
    !system $^X, $fatscript, "-nq", @argv;
}

1;
