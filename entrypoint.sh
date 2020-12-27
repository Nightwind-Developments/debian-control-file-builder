#!/bin/sh -l

#
# Copyright (C) 2020  Nightwind Future Industries Ltd. (NZ)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License,
# or any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.
# If not, see <https://www.gnu.org/licenses/>.
#

# The following script was referenced from: https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
# And here: https://gist.github.com/jehiah/855086

# Parses the Argument Options
while [ "$1" != "" ]
do
key="$1"
data="$2"
case $key in
    -f|--config_file)
    DEB_CONFIG_FILE="$data"
    shift # past argument
    shift # past value
    ;;
    -df|--deps_file)
    DEB_DEPS_FILE="$data"
    shift # past argument
    shift # past value
    ;;
    -o|--output)
    DEB_CTRL_OUT="$data"
    shift # past argument
    shift # past value
    ;;
    *)
      echo "ERROR: Invalid parameter key (\"$key\")"
      usage
      exit 1
esac
done

# Lists the Arguments that were found
echo ""
echo "Arguments Read from Entrypoint Script:"
echo "CONFIGURATION FILE  = ${DEB_CONFIG_FILE}"
echo "DEPENDENCY FILE     = ${DEB_DEPS_FILE}"
echo "CONTROL FILE OUTPUT = ${DEB_CTRL_OUT}"

echo ""
echo "Running Debian Control File Builder:"
DCB_ARGS="-f ${DEB_CONFIG_FILE} -df ${DEB_DEPS_FILE}"
# Appends output path to arguments variable if one is provided
if ${DEB_CTRL_OUT} ; then
  DCB_ARGS="${DCB_ARGS} -o ${DEB_CTRL_OUT}"
fi
# Runs the Debian Control File Generator, Reports if it was Successful
echo "Parameters: ${DCB_ARGS}"
if dcb "${DCB_ARGS}" ; then
  echo "Success"
  echo "::set-output name=control_file_path::${DEB_CTRL_OUT}/control"
else
  echo "App Failed"
fi