#!/bin/sh
name=urchin-$(../urchin --version)

tmp=$(mktemp -d)
mkdir $tmp/urchin
cp ../urchin ../readme.md ../AUTHORS ../COPYING $tmp/urchin
cd $tmp
tar czf $name.tar.gz $name
cd - > /dev/null
mv $tmp/$name.tar.gz .
rm -R $tmp
