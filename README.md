# NAME

Carl - yet another Carton

# SYNOPSIS

Development time:

    > carl install
    ...
    Complete! Modules were installed to local, and wrote index.txt

    > git add index.txt
    > git commit -m 'add index.txt'

Deployment time, only cpanm!

    > cpanm --mirror-index $PWD/index.txt -nq -Llocal --installdeps .

# DESCRIPTION

Carl is yet another Carton.

# FEATURES

- (1) use index.txt (02packages.details.txt) to save versions
- (2) so, when deployment, no need to install Carl itself, just cpanm
- (3) support git/dist dependencies

How does index.txt looks like? See [this](https://github.com/shoichikaji/Carl/blob/master/index.txt).

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

# SEE ALSO

Much code or architecture are stolen from Carton and Carmel.

[Carton](https://metacpan.org/pod/Carton)

[Carmel](https://github.com/miyagawa/Carmel)

[App::cpanminus](https://metacpan.org/pod/App::cpanminus)

[https://github.com/miyagawa/cpan-module-bootstrap](https://github.com/miyagawa/cpan-module-bootstrap)

[OrePAN2](https://metacpan.org/pod/OrePAN2)

[cpanfile](https://metacpan.org/pod/cpanfile)

[https://speakerdeck.com/miyagawa/whats-new-in-carton-and-cpanm-at-yapc-asia-2013](https://speakerdeck.com/miyagawa/whats-new-in-carton-and-cpanm-at-yapc-asia-2013)

[Perl::PrereqDistributionGatherer](https://github.com/shoichikaji/Perl-PrereqDistributionGatherer)

# LICENSE

Copyright (C) 2016 Shoichi Kaji <skaji@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Shoichi Kaji <skaji@cpan.org>
