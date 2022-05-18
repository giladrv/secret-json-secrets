#!/bin/bash
# set -euo pipefail
secret_json="${1}"
key_pattern="${2}"
val_pattern="${3}"
ignore_case="$(echo "${4}" |  tr '[:upper:]' '[:lower:]' )"
verbose="${5}"
[[ "${verbose}" == '1' ]] && echo "secret_json='${secret_json}'"
[[ "${verbose}" == '1' ]] && echo "key_pattern='${key_pattern}'"
[[ "${verbose}" == '1' ]] && echo "val_pattern='${val_pattern}'"
[[ "${verbose}" == '1' ]] && echo "ignore_case='${ignore_case}'"
if [[ "${ignore_case}" =~ ^1|y(es)?|t(rue)?$ ]]
then
    [[ "${verbose}" == '1' ]] && echo "nocasematch"
    shopt -qs nocasematch
fi
secret_keys=($(echo ${secret_json} | jq -r 'keys[]'))
[[ "${verbose}" == '1' ]] && echo "#keys=${#secret_keys[@]}"
for secret_key in "${secret_keys[@]}"
do
    secret_value=$( echo "${secret_json}" | jq -r ".${secret_key}" )
    if [[ "${secret_key}" =~ ${key_pattern} || \
        ! -z "${val_pattern}" && "${secret_value}" =~ ${val_pattern} ]]
    then
        echo "::add-mask::${secret_value}"
    fi
    [[ "${verbose}" == '1' ]] && echo "  ${secret_key}='${secret_value}'"
done
