#!/bin/sh

help () {
    echo "usage: $0 [-h] [-f]"
}

map_symlink () {
    src=$1
    dst=$2
    abssrc="$topdir/$src"
    if [ ! -f "$src" ]; then
        echo "WARNING: not found: $src"
    elif [ !  -e "$dst" ]; then
        echo "$dst -> $abssrc"
        ln -s "$abssrc" "$dst"
    elif [ -h "$dst" -a "`readlink "$dst"`" = "$abssrc" ]; then
        echo "$dst is already installed"
    elif [ $force = yes ]; then
        echo "$dst -> $abssrc"
        if [ -h "$dst" ]; then
            rm -f "$dst"
        else
            rm -f "$dst.old"
            mv "$dst" "$dst.old"
            echo "backed up to $dst.old"
        fi
        ln -s "$abssrc" "$dst"
    else
        echo "WARNING: not overwriting alien file: $dst"
    fi
}

process () {
    find . -mindepth 1 \( -name ".*" -prune -or -type d -print \) | while read dir; do
        dir=${dir##./}
        mapping="$dir/MAPPING"
        if [ -f "$mapping" ]; then
            cat "$mapping" | while read src dst; do
                map_symlink "$dir/$src" "$HOME/$dst"
            done
        else
            find "$dir" -maxdepth 1 -type f | while read src; do
                srcname=`basename "$src"`
                case "$srcname" in
                    .*|*~|*.swp)  ;; # skip
                    dot.*)  map_symlink "$src" "$HOME/${srcname##dot}";;
                    *)      echo "WARNING: skipping unknown file: $src"
                esac
            done
        fi
    done
    ls -a "$HOME" | while read dst; do
        dst="$HOME/$dst"
        if [ ! -h "$dst" ]; then
            continue
        fi
        src=`readlink "$dst"`
        if [ "${src##$topdir}" != "$src" ] && [ ! -f "$src" ]; then
            echo "$dst: broken link"
            rm -fv "$dst"
        fi
    done
}


IFS=""
cd `dirname "$0"`
topdir=`pwd`
force=no

opt=`getopt hf $*`
if [ $? != 0 ]; then
    help
    exit 1
fi
eval set -- $opt
while [ -n "$1" ]; do
    case "$1" in
        -h) help; exit 0;;
        -f) force=yes; shift;;
        --) shift; break;;
    esac
done

process

