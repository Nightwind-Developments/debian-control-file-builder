import json
import os
import shutil
import click


# Mandatory Keys Not Found Error/Exception
class MandatoryKeyNotFoundError(Exception):

    def __init__(self, missing_keys):
        self.missing_keys = missing_keys
        self.message = "The Following Keys were missing: " + self.missing_keys


# Debian Control Class
class DebControl:

    MK_PACKAGE = 0
    MK_VERSION = 1
    MK_ARCH = 2
    MK_MAINTAIN = 3
    MK_DESCRIPTION = 4
    MANDATORY_KEYS = ["Package", "Version", "Architecture", "Maintainer", "Description"]

    # Default Class Constructor
    def __init__(self, name, ver, arch, maint, des):
        self.dependencies = list()
        self.data = dict()

        self.data[self.MANDATORY_KEYS[self.MK_PACKAGE]] = name
        self.data[self.MANDATORY_KEYS[self.MK_VERSION]] = ver
        self.data[self.MANDATORY_KEYS[self.MK_ARCH]] = arch
        self.data[self.MANDATORY_KEYS[self.MK_MAINTAIN]] = maint
        self.data[self.MANDATORY_KEYS[self.MK_DESCRIPTION]] = des

    # Class Constructor for JSON file
    def __init__(self, config_file_path):
        json_file = open(config_file_path)
        temp_dict = json.load(json_file)
        temp_dict_keys = temp_dict.keys()

        # Ensures Imported List Contains at minimum the Mandatory Keys
        mk_not_found = list()
        for mk in self.MANDATORY_KEYS:
            if mk not in temp_dict_keys:
                mk_not_found.append(mk)
        if mk_not_found:
            raise MandatoryKeyNotFoundError(mk_not_found)

        self.data = temp_dict
        self.dependencies = list()

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

