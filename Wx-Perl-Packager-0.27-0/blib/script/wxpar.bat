@rem = '--*-Perl-*--
@set "ErrorLevel="
@if "%OS%" == "Windows_NT" @goto WinNT
@perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
@set ErrorLevel=%ErrorLevel%
@goto endofperl
:WinNT
@perl -x -S %0 %*
@set ErrorLevel=%ErrorLevel%
@if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" @goto endofperl
@if %ErrorLevel% == 9009 @echo You do not have Perl in your PATH.
@goto endofperl
@rem ';
#!/usr/bin/perl
#line 16

############################################################
#
# Simple assistant for use with wxPerl and PAR
#
# Copyright (c) 2006 & 2010 Mark Dootson mdootson@cpan.org
#
############################################################

=head1 NAME

wxpar

=head1 VERSION

Version 0.26

=cut

=head1 SYNOPSIS

    PAR assistant for packaging Wx applications on MSWin and Linux
    
    run 'wxpar' exactly as you would run pp.
        
    e.g.  wxpar --gui --icon=myicon.ico -o myprog.exe myscript.pl

    At the start of your script ...
    
    use Wx::Perl::Packager;
    use Wx;
    .....
    
    or if you use threads with your application
    
    use threads;
    use threads::shared;
    use Wx::Perl::Packager;
    use Wx
    
    Wx::Perl::Packager must be loaded before any part of Wx so should appear at the
    top of your main script. If you load any part of Wx in a BEGIN block, then you
    must load Wx::Perl::Packager before it in your first BEGIN block. This may cause
    you problems if you use threads within your Wx application. The threads
    documentation advises against loading threads in a BEGIN block - so don't do it.
    
    wxpar will accept a single named argument that allows you to define how the
    wxWidgets libraries are named on GTK.
    wxpar ordinarily packages the libraries as wxbase28u_somename.so.0
    This will always work if using Wx::Perl::Packager.
    However, it maybe that you don't want to use Wx::Perl::Packager, in which case
    you need the correct extension. For most installations the default '.0' IS the
    correct extension - so in most cases you need do nothing.
    
    If, however, you receive errors that suggest, for example, that
    wxbase28u_somename.so.5 could not be found, you want librararies packaged as
    wxbase28u_somename.so.5 so pass two arguments to wxpar as
    
    wxpar wxextension .5
    
    If you want wxbase28u_somename.so.0.6.0 , for example
    
    wxpar wxextension .0.6.0
    
    which would mean a full line something like
    
    wxpar wxextension .0.6.0 -o myprog.exe myscript.pl
    
    NOTE: the arguments must be FIRST and WILL BREAK Wx::Perl::Packager (which should
    not be needed in this case as all libraries should be on your LD_LIBRARY_PATH and
    named so that your par binary finds them).
    
    OF COURSE - the symlinks must actually exist. :-) - That is, if you pass
    
    wxpar wxextension .0.6.0 -o myprog.exe myscript.pl
    
    then wxbase28u_somename.so.0.6.0 etc. must be real files or symlinks on your
    system.


=cut
use File::Copy;
my @args = @ARGV;
my $VERSION = 0.18;

require Win32 if $^O =~ /^mswin/i;

my $addextension = '.0';

if ( $args[0] eq 'wxextension' ) {
    shift @args;
    $addextension = shift @args;
}


# get the outputpath, get argfilepath
my ($i, $ix, $execpath, $argfile );

for ($i = 0; $i < @args; $i++) {
    if($ix) {
        $execpath = $args[$i];
        last;
    }
    if(($args[$i] eq '-o') || ($args[$i] eq '--output')) { $ix = 1; }
}
if($execpath) {
    my @parts = split(/[\\\/]/, $execpath);
    if( (scalar @parts) > 1 ) {
        my $exec = pop(@parts);
        $exec =~ s/\.exe$//i;
        my $dirpath = join('/', @parts);
        if(-d $dirpath) {
            if($^O =~ /^MSWin/) { $dirpath = Win32::GetShortPathName($dirpath); }
        } else {
            die qq(target directory $dirpath does not exist);
        }
        $argfile = qq($dirpath/$exec.wxparargs);
        
        
    } elsif( (scalar @parts) == 1 ) {
        my $exec = pop(@parts);
        $exec =~ s/\.exe$//i;
        $argfile = "$exec.wxparargs";
        
    }
}

require Wx::Mini;
    
my $wxdir = $Wx::wx_path;
my $wxdlls = $Wx::dlls;

my @fileargs = ();

foreach my $dllname(keys(%$wxdlls)) {
    my $dllfilename = $wxdlls->{$dllname};
    $dllfilename =~ s/so[0-9\.]*$/so$addextension/;
    my $filepath = $wxdir . '/' . $dllfilename;
    $filepath =~ s/\\/\//g;
    unshift(@fileargs, qq(-l $filepath));
}

# add mingw32 or mingw-w64 runtime if present
if($^O =~ /^mswin/i) {
    my $mingw32dll = _set_mingwdll($wxdir);
    $mingw32dll =~ s/\\/\//g;
    if(-f $mingw32dll) {
        unshift(@fileargs, qq(-l $mingw32dll));
    }
}

# add attributes - always needed by Wx

unshift(@fileargs, qq(-M attributes.pm));

my $command = 'pp';
my $arglist = '';

if($argfile) {
    open my $fh, '>', $argfile;
    print $fh q(# wxpar Getopt::Argfile for PAR::Packer pp) . "\n\n";
    print$fh qq($_\n) for(@fileargs);
    close($fh);
    unshift(@args, qq(\@$argfile));
}   

for my $argument (@args) {
    if($argument =~ /\s/) {
        $arglist .= '"' . $argument . '" ';
    } else {
        $arglist .= $argument . ' ';
    }
}

print qq(\nRunning Command .....\n\n);
print qq($command $arglist\n);
print qq(\n .....\n\n);

my $fullcommand = qq($command $arglist); 
#system($command, @args );
system($fullcommand);

sub _set_mingwdll {
    my($dir) = @_;
    my $defaultmingw = 'mingwm10.dll';
    opendir(MYWXDIR, $dir) or die qq(Unable to open directory $dir : $!);
    my @mingfiles = grep { /^libgcc_/ } readdir(MYWXDIR);
    closedir(MYWXDIR);
    if($mingfiles[0] && (-f qq($dir/$mingfiles[0]))) {
        $defaultmingw = $mingfiles[0];
    }
    return qq($dir/$defaultmingw);
}

1;

__END__
__END__
:endofperl
@set "ErrorLevel=" & @goto _undefined_label_ 2>NUL || @"%COMSPEC%" /d/c @exit %ErrorLevel%
