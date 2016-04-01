#!/bin/sh
name=urchin-$(../urchin --version)

tmp=$(mktemp -d)
mkdir $tmp/$name
cp ../urchin ../readme.md ../AUTHORS ../COPYING $tmp/$name
cd $tmp
tar czf $name.tar.gz $name
cd - > /dev/null
mv $tmp/$name.tar.gz .
rm -R $tmp
