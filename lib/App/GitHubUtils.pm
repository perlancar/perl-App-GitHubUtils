package App::GitHubUtils;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::ger;

our %SPEC;

$SPEC{create_the_github_repo} = {
    v => 1.1,
    summary => 'Create github repo',
    description => <<'_',

This is a convenient no-argument-needed command to create GitHub repository.
Will use prog:github-cmd from pm:App::github::cmd to create the repository. To
find out the repo name to be created, will first check .git/config if it exists.
Otherwise, will just use the name of the current directory.

_
    args => {
    },
    deps => {
        prog => 'github-cmd',
    },
};
sub create_the_github_repo {
    require App::GitUtils;

    [200, "OK", $user];

    my $res = App::GitUtils::info();

    use DD; dd $res;

    [200];
}

1;
# ABSTRACT:

=head1 DESCRIPTION

This distribution provides the following command-line utilities related to
GitHub:

#INSERT_EXECS_LIST


=head1 SEE ALSO

L<github-cmd> from L<App::github::cmd>

L<Net::GitHub>

L<Pithub>
