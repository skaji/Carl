package Carl;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";
1;
__END__

=encoding utf-8

=head1 NAME

Carl - yet another Carton

=head1 SYNOPSIS

Development time:

    > carl install
    ...
    Complete! Modules were installed to local, and wrote index.txt

    > git add index.txt
    > git commit -m 'add index.txt'

Deployment time, only cpanm!

    > cpanm --mirror-index $PWD/index.txt -nq -Llocal --installdeps .

=head1 DESCRIPTION

Carl is yet another Carton.

=head1 FEATURES

=over 4

=item (1) use index.txt (02packages.details.txt) to save versions

=item (2) so, when deployment, no need to install Carl itself, just cpanm

=item (3) support git/dist dependencies

=back

How does index.txt looks like? See L<this|https://github.com/shoichikaji/Carl/blob/master/index.txt>.

Let me explain (3).
Suppose you have the following cpanfile:

    requires 'My::Module', git => 'git://ghe.example.com/you/My-Module.git', ref => '0.01';
    requires 'Anthor::Module', dist => 'http://darkpan.example.com/Anothor-Module-0.01.tar.gz';

Carl supports it!

    > carl install
    ...
    Complete! Modules were installed to local, and wrote index.txt

    # I recommend you to git-add local/cache
    > git add index.txt local/cache
    > git commit -m 'add index.txt and local/cache for consistent installation'

    # deployment time!
    > cpanm --mirror-index $PWD/index.txt --mirror file://$PWD/local/cache -nq -Llocal --installdeps .

=head1 SEE ALSO

Much code or architecture are stolen from Carton and Carmel.

L<Carton>

L<Carmel|https://github.com/miyagawa/Carmel>

L<App::cpanminus>

L<https://github.com/miyagawa/cpan-module-bootstrap>

L<OrePAN2>

L<cpanfile>

L<https://speakerdeck.com/miyagawa/whats-new-in-carton-and-cpanm-at-yapc-asia-2013>

L<Perl::PrereqDistributionGatherer|https://github.com/shoichikaji/Perl-PrereqDistributionGatherer>

=head1 LICENSE

Copyright (C) 2016 Shoichi Kaji <skaji@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Shoichi Kaji E<lt>skaji@cpan.orgE<gt>

=cut

