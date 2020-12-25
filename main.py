import json
import os
import shutil
import click


# Makes a new directory if it does not exist
def mkdir_if_not_exist(path):
    if not os.path.exists(path):
        os.mkdir(path)


# Mandatory Keys Not Found Error/Exception
class MandatoryKeyNotFoundError(Exception):

    def __init__(self, missing_keys, is_json):
        self.missing_keys = missing_keys
        if is_json:
            self.message = "[In JSON File]"
        else:
            self.message = "[In Parameters]"
        self.message += " The Following Keys were missing: " + self.missing_keys


# Debian Control Class
class DebControl:

    # Argument Parameter Keys
    CONFIG_FILE_ARG = "config_file"

    # File Names
    CTRL_FILE_NAME = "Control"

    # Keywords
    DEPENDS_KEYWORD = "Depends"

    # Commonly Used Syntax within File
    COLON = ": "
    COMMA = ", "

    MANDATORY_KEYS = ["Package", "Version", "Architecture", "Maintainer", "Description"]
    OTHER_DATA_KEYS = list()

    # Class Constructor
    def __init__(self, **named_args):

        config_file_path = named_args[self.CONFIG_FILE_ARG]

        # JSON Configuration File Case
        if config_file_path:
            json_file = open(config_file_path)
            temp_dict = json.load(json_file)
            temp_dict_keys = temp_dict.keys()
        # Parameters Case
        else:
            temp_dict_keys = named_args.keys()
            temp_dict = named_args

        # Ensures Imported List Contains at minimum the Mandatory Keys
        mk_not_found = list()
        for mk in self.MANDATORY_KEYS:
            if mk not in temp_dict_keys:
                mk_not_found.append(mk)
        if mk_not_found:
            raise MandatoryKeyNotFoundError(mk_not_found, bool(config_file_path))

        # Saves Configuration Data
        self.data = temp_dict

        # Initialises Dependencies List
        self.dependencies = list()

        # Saves Non-Mandatory Keys
        self.OTHER_DATA_KEYS = [x for x in self.data.keys() if x not in self.MANDATORY_KEYS]

    # Parses Dependency File to Save Dependencies
    def parse_deps_file(self, deps_list_file_path):
        try:
            with open(deps_list_file_path) as deps_file:
                dep_entry = deps_file.readline()
                while dep_entry:
                    self.dependencies.append(dep_entry)
                    dep_entry = deps_file.readline()
        except IOError:
            print("Dependency File not found")
            exit(-2)

    # Builds Debian Control File
    def build_control_file(self, output_path):
        mkdir_if_not_exist(output_path)
        output_path_full = output_path + self.CTRL_FILE_NAME
        build_file = open(output_path_full, "w")

        # Writes Mandatory Configurations First
        for i in self.MANDATORY_KEYS:
            line = i + self.COLON + self.data[i]
            build_file.write(line)

        # Writes Required Dependencies
        deps_line = self.COMMA.join(self.dependencies)
        deps_line_full = self.DEPENDS_KEYWORD + self.COLON + deps_line
        build_file.write(deps_line_full)

        # Writes Other Configurations Last
        for i in self.OTHER_DATA_KEYS:
            line = i + self.COLON + self.data[i]
            build_file.write(line)

