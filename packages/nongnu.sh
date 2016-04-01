#!/bin/sh
tmp=$(mktemp -d)
mkdir $tmp/urchin
cp ../urchin ../readme.md ../AUTHORS ../COPYING $tmp/urchin
cd $tmp
tar czf urchin.tar.gz urchin
cd -
mv $tmp/urchin.tar.gz .
rm -R $tmp
