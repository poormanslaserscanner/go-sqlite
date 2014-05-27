#!/bin/bash

# folder prefix
p="../../go-sqlite"
# current dir
currentdir=$(pwd)
# grep version
v=$(grep Version ../DESCRIPTION |awk '{print $2}')

# delete all go-sqlite files in /tmp
rm /tmp/go-sqlite*

# make .tar.gz
tar cfvz /tmp/go-sqlite-"$v"-GPLv3.tar.gz {"$p"/inst,"$p"/doc/*.html,"$p"/INDEX,"$p"/DESCRIPTION,"$p"/README.md}

# make .tar.xz
tar cfvJ /tmp/go-sqlite-"$v"-GPLv3.tar.xz {"$p"/inst,"$p"/doc/*.html,"$p"/INDEX,"$p"/DESCRIPTION,"$p"/README.md}

# make .7z
tar C /tmp/ -xf /tmp/go-sqlite-"$v"-GPLv3.tar.gz
cd /tmp && 7za a /tmp/go-sqlite-"$v"-GPLv3.7z go-sqlite/ && 7za a -tzip /tmp/go-sqlite-"$v"-GPLv3.zip go-sqlite/

# make gpl-free version
rm /tmp/go-sqlite/inst/\@sqlite/private/serialize.m
# change license in DESCRIPTION
sed -i 's/GPLv3/WTFPL/' /tmp/go-sqlite/DESCRIPTION

tar cfz go-sqlite-"$v"-WTFPL.tar.gz go-sqlite/
tar cfJ go-sqlite-"$v"-WTFPL.tar.xz go-sqlite/
7za a go-sqlite-"$v"-WTFPL.7z go-sqlite/
7za a -tzip go-sqlite-"$v"-WTFPL.zip go-sqlite/

# delete /tmp/go-sqlite/ folder
rm -rf /tmp/go-sqlite/
cd "$currentdir"

# move files to devel
mv /tmp/go-sqlite* ./
