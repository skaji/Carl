requires 'perl', '5.008001';
requires 'App::cpanminus';
requires 'JSON::PP';
requires 'Module::CPANfile';
requires 'Module::Metadata';
requires 'CPAN::Mirror::Tiny';

requires 'Perl::PrereqDistributionGatherer',
    git => 'git://github.com/shoichikaji/Perl-PrereqDistributionGatherer.git';

on test => sub {
    requires 'Test::More', '0.98';
};
