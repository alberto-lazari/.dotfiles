#!/bin/bash -e

cd $(dirname $BASH_SOURCE)

DIR=~/.emacs.d

. ../lib/setup-base.sh

link_files_in . -t $DIR
