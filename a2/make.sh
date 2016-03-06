#!/bin/sh

MAKEPRG=bmake
MAKEFLAGS="-j4"

if [ $# -ne 1 ]; then
    echo "Usage: ./compile [norand|rand], where norand=ASST2-NORAND, rand=ASST2-RAND"
fi

kernel_arg=$1

echo "Is this the first time you're running this script? [y/n]. Press enter"
read ans
if [ $ans = "y" ]; then
    chmod +x -R .
fi

current=`pwd`

# A Simple bash script to configure and compile os/161
echo "Configuring your tree for the machine on which you are working"
# cd ./src
# -------------------CHANGE ROOT PATH HERE ----------------------
./configure --ostree=$HOME/cscc69w16/root

if [ $kernel_arg = "norand" ]; then
    kernel="ASST2-NORAND"
elif [ $kernel_arg = "rand" ]; then
    kernel="ASST2-RAND"
else
    echo "Invalid argument!"
    exit
fi

echo
echo "Configuring kernel named $kernel"
cd kern/conf
./config $kernel || exit

echo
echo "Building the $kernel kernel"
cd ../compile/$kernel
${MAKEPRG} ${MAKEFLAGS} depend || exit
${MAKEPRG} ${MAKEFLAGS} || exit 

echo
echo "Installing $kernel kernel"
${MAKEPRG} ${MAKEFLAGS} install || exit

echo
echo "Building user-level utilities"
cd ../../..
bmake clean
${MAKEPRG} ${MAKEFLAGS} || exit
${MAKEPRG} ${MAKEFLAGS} install ||exit
#ctags -R .

echo
echo "Copying sys161.conf file to the root"
# -------------------CHANGE ROOT PATH HERE ----------------------
cp $current/sys161.conf /cmshome/ganyue/cscc69w16/root