package Carl::LocalMirror;
use 5.008001;
use strict;
use warnings;
use CPAN::Mirror::Tiny;
use Module::CPANfile;

sub new {
    my ($class, %option) = @_;
    my $directory = delete $option{directory} or die;
    my $cpanfile  = delete $option{cpanfile}  or die;
    bless { %option, cpanfile => $cpanfile, directory => $directory }, $class;
}

sub debug {
    my $self = shift;
    return unless $self->{debug};
    warn "--> @_\n";
}

sub setup {
    my $self = shift;

    my $cpanfile = Module::CPANfile->load($self->{cpanfile});
    my @module = $cpanfile->merged_requirements->required_modules;

    my @need_inject;
    for my $module (@module) {
        my $option = $cpanfile->options_for_module($module) || +{};
        if (my $git = $option->{git}) {
            $git = "$git\@$option->{ref}" if $option->{ref};
            push @need_inject, { module => $module, from => $git };
        } elsif (my $dist = $option->{dist}) {
            # which dist support? read OrePAN2::Injector :-)
            push @need_inject, { module => $module, from => $dist };
        }
    }
    return unless @need_inject;

    my $directory = $self->{directory};
    $self->debug("building local repository $directory");
    my $cpan = CPAN::Mirror::Tiny->new(base => $directory);
    for my $module (@need_inject) {
        $self->debug("injecting $module->{module} from $module->{from}");
        $cpan->inject($module->{from});
    }
    $self->debug("indexing $directory");
    $cpan->write_index;
    return 1;
}

1;
