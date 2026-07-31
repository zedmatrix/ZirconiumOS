#!/bin/bash

source "${PWD}/ybase_header.sh" || { echo "Can Not Base Header"; exit 127; }
repository="/ybuild/repos/perl_depend"

###     Optional
zprint "Building Perl Testsuite Modules"
zbuild_wait 5
test_suite=(Test-Simple Test-Warnings Test-Needs Test-Fatal Test-RequiresInternet Test-Requires Test-Deep)
for pkg in ${test_suite[@]}; do
    zmsg "Next Package: ${pkg}"
    zbuild_wait 5
    ${PWD}/Ybuild "${repository}/${pkg}.yaml" || { zerror "Error in ${pkg}. Exiting."; exit 1; }
done

###     Perl XML Modules
zprint "Building Perl XML Modules"
zbuild_wait 5
perl_xml=(XML-SAX-Base-1.09  XML-NamespaceSupport-1.12  XML-SAX-1.02  Path-Tiny-0.150  File-chdir-0.1011  File-Which-1.27
    Capture-Tiny-0.50  Term-Table-0.028  FFI-CheckLib-0.31  Alien-Build-2.84  MIME-Base32-1.303  Try-Tiny-0.32  URI-5.34
    Alien-Build-Plugin-Download-GitLab-0.01  Alien-Libxml2-0.20  XML-LibXML-2.0213  XML-LibXML-Simple-1.01)

for pkg in ${perl_xml[@]}; do
    zmsg "Next Package: ${pkg}"
    zbuild_wait 5
    ${PWD}/Ybuild "${repository}/${pkg}.yaml" || { zerror "Error in ${pkg}. Exiting."; exit 1; }
done

### Builder Modules for 2 new modules
zprint "Building Module::Build::Tiny"
zbuild_wait 5
perl_build=(ExtUtils-Config-0.010 ExtUtils-Helpers-0.028 ExtUtils-InstallPaths-0.015 Module-Build-Tiny-0.053)
for pkg in ${perl_build[@]}; do
    zmsg "Next Package: ${pkg}"
    zbuild_wait 5
    ${PWD}/Ybuild "${repository}/${pkg}.yaml" || { zerror "Error in ${pkg}. Exiting."; exit 1; }
done

###   Perl Depends for XScreenSaver
zprint "Building Perl Modules for XScreensaver"
zbuild_wait 5
package_list=(IO-HTML-1.004  TimeDate-2.35  HTTP-Date-6.06  File-Listing-6.16  Encode-Locale-1.05
  B-COW-0.007  Clone-0.50  HTML-Tagset-3.24  Net-HTTP-6.24  LWP-MediaTypes-6.04  HTTP-Message-7.01
  HTTP-Negotiate-6.01  HTTP-Cookies-6.11  HTTP-Daemon-6.17  HTTP-CookieJar-0.014  HTML-Parser-3.85
  WWW-RobotRules  libwww-perl-6.83  Net-SSLeay-1.96  IO-Socket-SSL-2.098  LWP-Protocol-https-6.15)

for pkg in ${package_list[@]}; do
    zmsg "Next Package: ${pkg}"
    zbuild_wait 5
    ${PWD}/Ybuild "${repository}/${pkg}.yaml" || { zerror "Error in ${pkg}. Exiting."; exit 1; }
done
