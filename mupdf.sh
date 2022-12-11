#!/bin/bash

# requires wslpath @ https://github.com/laurent22/wslpath

new_arg=()
declare -i idxMntOccur=0

for arg in "$@"
do
    echo arg $arg
    if [[ "$arg" == /mnt* ]]
    then
        # convert to windows style path
        idxMntOccur=idxMntOccur+1
        winPath=$(wslpath -m "$arg")
        new_arg+=$winPath
        if [[ $idxMntOccur == 1 ]]
        then
          # convert the path in .syntex to windows style
          # run only "/mnt/d" like path[ is detected
          find ${PWD} -maxdepth 1 -name "*.synctex.gz" -execdir \
            bash -c 'cat "{}" | gunzip | sed --expression="s@/mnt/\(.\)/@\1:/@g" | gzip > "{}.tmp" && mv "{}.tmp" "{}"' \;
        fi
    else
        new_arg+=" $arg "
    fi

done

$(mupdf "$new_arg")
