function __print_extra_functions_help() {
cat <<EOF
Additional functions:
- cout:            Changes directory to out.
- repopick:        Utility to fetch changes from Gerrit.
- sort-blobs-list: Sort proprietary-files.txt sections with LC_ALL=C.
- aospmerge:       Utility to merge AOSP tags.
EOF
}

function breakfast()
{
    target=$1
    STATIX_DEVICES_ONLY="true"
    unset LUNCH_MENU_CHOICES
    for f in `/bin/ls vendor/statix/vendorsetup.sh 2> /dev/null`
        do
            echo "including $f"
            . $f
        done
    unset f

    if [ $# -eq 0 ]; then
        # No arguments, so let's have the full menu
        echo "Nothing to eat for breakfast?"
        lunch
    else
        echo "z$target" | grep -q "-"
        if [ $? -eq 0 ]; then
            # A buildtype was specified, assume a full device name
            lunch $target
        else
            # This is probably just the StatiX model name
            lunch statix_$target-userdebug
        fi
    fi
    return $?
}

alias bib=breakfast

function brunch()
{
    breakfast $*
    if [ $? -eq 0 ]; then
        time m bacon
    else
        echo "No such item in brunch menu. Try 'breakfast'"
        return 1
    fi
    return $?
}

function cout()
{
    if [  "$OUT" ]; then
        cd $OUT
    else
        echo "Couldn't locate out directory.  Try setting OUT."
    fi
}

function repopick() {
    T=$(gettop)
    $T/vendor/statix/build/tools/repopick.py $@
}

function sort-blobs-list() {
    T=$(gettop)
    $T/tools/extract-utils/sort-blobs-list.py $@
}

function aospmerge()
{
    target_branch=$1
    T=$(gettop)
    python3 $T/vendor/statix/scripts/merge-aosp.py $target_branch
}
