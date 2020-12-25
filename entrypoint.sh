#!/bin/sh -l

# The following script was referenced from: https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -f|--config_file)
    DEB_CONFIG_FILE="$2"
    shift # past argument
    shift # past value
    ;;
    -d|--deps_file)
    DEB_DEPS_FILE="$2"
    shift # past argument
    shift # past value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo "CONFIGURATION FILE  = ${DEB_CONFIG_FILE}"
echo "DEPENDENCY FILE     = ${DEB_DEPS_FILE}"