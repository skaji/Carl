requires 'perl', '5.008001';
requires 'App::cpanminus';
requires 'Capture::Tiny';
requires 'JSON::PP';
requires 'Module::CPANfile';
requires 'Module::Metadata';
requires 'OrePAN2::Indexer';
requires 'OrePAN2::Injector';

requires 'Perl::PrereqDistributionGatherer',
    git => 'git://github.com/shoichikaji/Perl-PrereqDistributionGatherer.git';

on test => sub {
    requires 'Test::More', '0.98';
};
