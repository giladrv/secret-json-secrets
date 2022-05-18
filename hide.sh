#!/bin/bash
# set -euo pipefail
secret_json="${1}"
key_pattern="${2}"
val_pattern="${3}"
ignore_case="$(echo "${4}" |  tr '[:upper:]' '[:lower:]' )"
verbose="${5}"
echo d1 "${verbose}"
[[ "${verbose}" == '1' ]] && echo "secret_json='${secret_json}'"
[[ "${verbose}" == '1' ]] && echo "key_pattern='${key_pattern}'"
[[ "${verbose}" == '1' ]] && echo "val_pattern='${val_pattern}'"
[[ "${verbose}" == '1' ]] && echo "ignore_case='${ignore_case}'"
echo d2
if [[ "${ignore_case}" =~ ^1|y(es)?|t(rue)?$ ]]
then
    [[ "${verbose}" == '1' ]] && echo "nocasematch"
    shopt -qs nocasematch
fi
echo d3
secret_keys=($(echo ${secret_json} | jq -r 'keys[]'))
[[ "${verbose}" == '1' ]] && echo "#keys=${#secret_keys[@]}"
echo d4
for secret_key in "${secret_keys[@]}"
do
    echo d5
    secret_value=$( echo "${secret_json}" | jq -r ".${secret_key}" )
    echo d6
    if [[ "${secret_key}" =~ ${key_pattern} || \
        echo d7
        ! -z "${val_pattern}" && "${secret_value}" =~ ${val_pattern} ]]
    then
        echo d8
        echo "::add-mask::${secret_value}"
    fi
    echo d9
    [[ "${verbose}" == '1' ]] && echo "  ${secret_key}='${secret_value}'"
done
