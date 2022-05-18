#!/bin/bash
secret_json="${1}"
key_pattern="${2}"
echo "secret_json='${secret_json}'"
echo "key_pattern='${key_pattern}'"
secret_keys=($(echo ${secret_json} | jq -r 'keys[]'))
for secret_key in "${secret_keys[@]}"
do
    secret_value=$( echo "${secret_json}" | jq -r ".${secret_key}" )
    if [[ "${secret_key}" =~ ${key_pattern} ]]
    then
        echo "::add-mask::'${secret_value}'"
    fi
    echo "${secret_key}='${secret_value}'"
done
