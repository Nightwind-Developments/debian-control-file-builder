# Debian Control File Builder

[![Latest Build](https://github.com/Nightwind-Developments/debian-control-file-builder/actions/workflows/latest_file_builder.yaml/badge.svg?branch=main)](https://github.com/Nightwind-Developments/debian-control-file-builder/actions/workflows/latest_file_builder.yaml)

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

This GitHub Action and the software included is designed to complement another one of our projects, 
[Debian Packer](https://github.com/Nightwind-Developments/debian-packer).

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
    runs-on: ubuntu-24.04

    steps:
        # Generate Debian control File
      - name: Generate Debian control File
        uses: Nightwind-Developments/debian-control-file-builder@latest
        id: deb_control
        # Input Parameters
        with:
          # Required: Configuration File
          config-file: 'path/to/control_configuration_file.json'
          # Optional: deps-file
          deps-file: 'path/to/product_dependencies_list_file.txt'
          # Optional: Custom Output Directory
          output-path: 'desired/path/to/generated/file/named/control'
          # Optional: Case Sensitive JSON Keys
          case-sensitive-keys: 'true'
        
        # Upload the Generated control File as an Artifact
      - name: Upload Generated Control File
        uses: actions/upload-artifact@v4
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
| `case-sensitive-keys` | String | No | 'true' | Signals whether the JSON keys of the template file require conversion to Debian's Standards (Capitalised first letter, remaining letters lowercase). Use 'true' if keys are already in correct form and conversion is NOT required, 'false' if conversion IS required. |

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
* [Asami De Almeida](https://github.com/RedHoodedWraith) - theengineer@redhoodedwraith.com

## Copyright & Licensing
Copyright (C) 2020  Nightwind Developments <hello@nightwind-developments.co.nz>

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

