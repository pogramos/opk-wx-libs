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
#!/usr/bin/perl -w
#line 16
#############################################################################
## Name:        script/wxperl_overload
## Purpose:     builds overload constants
## Author:      Mattia Barbon
## Modified by:
## Created:     17/08/2001
## RCS-ID:      $Id: wxperl_overload 2335 2008-01-21 22:58:59Z mbarbon $
## Copyright:   (c) 2001-2003, 2005-2008 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

use FindBin;

use strict;
use lib "$FindBin::RealBin/../build";

=head1 NAME

wxperl_overload - create overload declarations for wxPerl extensions

=head1 SYNOPSIS

    # usually invoked from Makefile
    wxperl_overload <.cpp file> <.h file> files...

    wxperl_overload <.cpp file> <.h file> file.lst

=head1 DOCUMENTATION

This script if usually invoked from an
C<ExtUtils::MakeMaker>-generated file by using C<WX_OVERLOAD> in
F<Makefile.PL>.

Scans the files given on the command line or listed in the F<.lst>
file searching for wxPerl overload declarations.  Writes a F<.h> file
with matching F<.cpp> file containing the definition for wxPerl
overload constants.

=cut

use Wx::Overload::Driver;

my( $ovlc, $ovlh ) = ( shift, shift );

if( $ARGV[0] && $ARGV[0] =~ /\.lst$/ ) { # lame hack to read list from file
    open my $fh, "<", $ARGV[0] or die "$!";
    @ARGV = map { chomp; $_ } <$fh>;
}

my $driver = Wx::Overload::Driver->new
  ( files  => \@ARGV,
    header => $ovlh,
    source => $ovlc,
    );
$driver->process;

exit 0;
__END__
:endofperl
@set "ErrorLevel=" & @goto _undefined_label_ 2>NUL || @"%COMSPEC%" /d/c @exit %ErrorLevel%
