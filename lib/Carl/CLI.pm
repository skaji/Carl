package Carl::CLI;
use strict;
use warnings;
use Carl::Builder;
use Carl::Indexer;
use Carl::LocalMirror;
use Config;
use Cwd ();
use File::Temp ();

sub new {
    my ($class, %option) = @_;
    bless { %option }, $class;
}

sub run {
    my ($self, @argv) = @_;
    my $cmd = shift @argv || "help";
    if ( my $code = $self->can( "cmd_$cmd" ) ) {
        $self->$code(@argv);
    } else {
        warn "Unknown command $cmd.\n";
        $self->cmd_help;
    }
}

sub debug { $ENV{PERL_CARL_DEBUG} }

sub cmd_help {
    exec "perldoc", "Carl";
    exit 255;
}

sub cmd_install {
    my $self = shift;
    my $directory = File::Temp::tempdir(CLEANUP => !$self->debug);

    my $mirror = Carl::LocalMirror->new(
        directory => $directory,
        cpanfile => "cpanfile",
        debug => $self->debug,
    );
    my $setuped = $mirror->setup;

    my $builder = Carl::Builder->new(
        ( $setuped ? (mirror => $directory) : () ),
        directory => "local",
        cpanfile => "cpanfile",
    );
    $builder->install;

    my $indexer = Carl::Indexer->new(
        directory => "local/lib/perl5",
        cpanfile => "cpanfile",
    );

    open my $fh, ">", "index.txt.tmp" or die "Cannot open index.txt: $!";
    $indexer->write_index($fh);
    unlink "index.txt";
    rename "index.txt.tmp", "index.txt" or die "rename index.txt: $!";

    warn "Complete! Modules were installed to local, and wrote index.txt\n";
}

sub cmd_exec {
    my ($self, @argv) = @_;
    my $cwd = Cwd::cwd;
    $ENV{PERL5LIB} = ($ENV{PERL5LIB} ? "$ENV{PERL5LIB}:" : "") . "$cwd/local/lib/perl5";
    $ENV{PATH} = "$cwd/local/bin:$ENV{PATH}";
    exec @argv;
    exit 255;
}

1;
