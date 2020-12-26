# Debian Control File Builder

![Build Example](https://github.com/Nightwind-Developments/debian-control-file-builder/workflows/Build%20Example/badge.svg?branch=main)

## Contents
1. [Description](#description)
1. [Usage](#usage)
   1. [Simple Workflow](#simple-workflow)
   1. [Input Parameters](#input-parameters)
   1. [Output Variables](#output-variables)
   1. [JSON Control File Configuration](#json-control-file-configuration)
   1. [Dependencies List](#dependencies-list)
1. [Contributors](#contributors)
1. [Copyright & Licensing](#copyright--licensing)

## Description
This GitHub Action and its core application can generate a `control` file that can then be used to 
generate Debian Packages.
*Debian Control File Builder* is ideal for applications that require a `control` to be dynamically generated, such as 
generating a Debian Package as part of an automated release with CI/CD.

Further Information:
* [Debian Control File Specification](https://www.debian.org/doc/debian-policy/ch-controlfields.html)

## Usage
Here is a simple example of how you can use this Action in your Workflow:
### Simple Workflow
```yaml
name: Debian-Control-File-Build-Example
on:
  push:
    branches: [ master, main ]
  workflow_dispatch:
  
jobs:
  deb-control-file-build:
    name: Generate Debian Package
    runs-on: ubuntu-20.04

    steps:
        # Generate Debian control File
      - name: Generate Debian control File
        uses: 
        id: deb_control
        # Input Parameters
        with:
          # Required: Configuration File
          config-file: 'path/to/control_configuration_file.json'
          # Optional: deps-file
          deps-file: 'path/to/product_dependencies_list_file.txt'
          # Optional: Custom Output Directory
          output-path: 'desired/path/to/generated/file/named/control'
        
        # Upload the Generated control File as an Artifact
      - name: Upload Generated Control File
        uses: actions/upload-artifact@v2
        with:
          name: generated-control-file
          path: "${{ steps.deb_control.outputs.control_file_path }}"
          if-no-files-found: error
```

### Input Parameters
| Name          | Type   | Required | Default                           | Description |
|---------------|--------|----------|-----------------------------------|-------------|
| `config-file` | String | Yes      |                                   | Path to configuration file in JSON format |
| `deps-file`   | String | No       |                                   | Path to the file with the list of dependencies to include in the generated control file |
| `output-path` | String | No       | `${{ github.workspace }}/output/` | The path to where the generated control file will be saved |

Example use case for input parameters:
```yaml
  steps:
    - name: Step Name
      with:
        input-name: value
```

### Output Variables
| Name                | Type   | Description |
|---------------------|--------|-------------|
| `control_file_path` | String | The configured path where the generated control file is saved |

Example use case for output variables:
```yaml
    steps:
    - name: Step Name
      id: step-id
      run: ./

    - name: Print Output Variable
      run echo "${{ steps.step-id.outputs.output_variable }}"
```

### JSON Control File Configuration
A JSON File, formatted like below, can be used to specify what configurations the `control` file will have 
after generation. 

```JSON
{
  "First Configuration Name" : "Value to Assign",
  "Second Configuration Name" : "Value to Assign"
}
```

In the following example, only the mandatory fields for 
[Binary Debian Packages](https://www.debian.org/doc/debian-policy/ch-controlfields.html#binary-package-control-files-debian-control) 
have been set. 
```JSON
{
  "Package": "PackageName",
  "Version": "0.0.0",
  "Architecture": "armhf",
  "Maintainer": "A. Main-Tainer",
  "Description": "This is just a sample control file for a Debian package"
}
```
<br>This results in a file that looks like this:
```
Package: PackageName
Version: 0.0.0
Architecture: armhf
Maintainer: A. Main-Tainer
Description: This is just a sample control file for a Debian package
```

### Dependencies List
Here is an example of the Dependencies List file:
```
nano
build-essential
```
This produces a `Depends` configuration entry in the `control` file that looks like this:
```
Depends: nano, build-essential
```

## Contributors
The following developers have contributed to this repository:
* [Rowan Rathod](https://github.com/RedHoodedWraith) - rowan@nightwind-developments.co.nz

## Copyright & Licensing
Copyright (C) 2020  Nightwind Future Industries Ltd. (NZ) <https://nightwind-developments.co.nz/>
<hello@nightwind-developments.co.nz>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License,
or any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program, such as below this paragraph.
If those links are not accessible, see <https://www.gnu.org/licenses/>.

The license for code in this repository follows LGPL-3.0-or-later.
* [GNU Lesser General Public License](/COPYING.LESSER)
* [GNU General Public License](/COPYING)

