#!/bin/bash

#   perl-xml-libxml-simple.sh

package_list=(XML-SAX-Base XML-NamespaceSupport XML-SAX Path-Tiny File-chdir File-Which
    Capture-Tiny Term-Table Test-Simple FFI-CheckLib Alien-Build MIME-Base32 Test-Warnings
    Test-Needs Try-Tiny	Test-Fatal URI Alien-Build-Plugin-Download-GitLab Alien-Libxml2
	XML-LibXML XML-LibXML-Simple)

fail="false"
for pkg in ${package_list[@]}; do
    if [[ ! -f "repos/${pkg}.yaml" ]]; then
        echo "Error: Missing repos/${pkg} "
        fail="true"
    fi
done

if [[ $fail == "false" ]]; then
    for pkg in ${package_list[@]}; do
        ./pkg-install.sh ${pkg} || { echo "Error in ${pkg}. Exiting."; break; }
    done
else
    echo "Missing Repos File"
fi
