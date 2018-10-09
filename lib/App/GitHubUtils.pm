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
    require Cwd;
    require IPC::System::Options;

    my $repo;
  SET_REPO_NAME:
    {
        my $res = App::GitUtils::info();
        if ($res->[0] == 200) {
            my $content = do {
                local $/;
                my $path = "$res->[2]{git_dir}/config";
                open my $fh, "<", $path or die "Can't open $path: $!";
                <$fh>;
            };
            if ($content =~ m!^\s*url\s*=\s*.+/([^/]+)\.git\s*$!m) {
                $repo = $1;
                last;
            }
        }
        $repo = Cwd::getcwd();
        $repo =~ s!.+/!!;
    }
    log_info "Creating repo '%s' ...", $repo;

    my ($out, $err);
    IPC::System::Options::system({log=>1, capture_stdout=>\$out, capture_stderr=>\$err}, "github-cmd", "create-repo", $repo);
    my $exit = $?;

    if ($exit) {
        if ($out =~ /name already exists/) {
            return [412, "Failed: Repo already exists"];
        } else {
            return [500, "Failed: $out"];
        }
    } else {
        return [200, "OK", undef, {'func.repo'=>$repo}];
    }
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
