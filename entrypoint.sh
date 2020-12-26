#!/bin/sh -l

# The following script was referenced from: https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
# And here: https://gist.github.com/jehiah/855086

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
    -d|--deps_file)
    DEB_DEPS_FILE="$data"
    shift # past argument
    shift # past value
    ;;
    *)
      echo "ERROR: Invalid parameter key (\"$key\")"
      usage
      exit 1
esac
done

echo "\nArguments Read from Entrypoint Script:"
echo "CONFIGURATION FILE  = ${DEB_CONFIG_FILE}"
echo "DEPENDENCY FILE     = ${DEB_DEPS_FILE}"

echo "\nCurrent Runtime Directory:"
ls -la .

echo "Running Debian Control File Builder"
if dcb -f ${DEB_CONFIG_FILE} -df ${DEB_DEPS_FILE} ; then
  echo "Running App Succeeded"
else
  echo "Running App Failed"
fi