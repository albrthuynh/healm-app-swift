<!--
SPDX-FileCopyrightText: 2017 We
SPDX-License-Identifier: Apache-2.0
-->

# Heal'M Mobile App

Heal'M Mobile App development

# Developer Workflow

This project uses the [GitHub flow](https://docs.github.com/en/get-started/quickstart/github-flow)

# Getting Started with development


## Licensing compliance

This project is released under the Apache 2.0 license and license compliance is
handled with the [REUSE](http://reuse.software/) tool.
REUSE is installed as development dependency or you can install it manually
(`pip install reuse`). All files should have a license notice:

- to check compliance you can use `reuse lint`. This is the command run also by the pre-commit and CI checks
- you can add on top of new files [SPDX license notices](https://spdx.org/licenses/) like
  ```
  # SPDX-FileCopyrightText: 2022 Fermi Research Alliance, LLC
  # SPDX-License-Identifier: Apache-2.0
  ```
- or let REUSE do that for you (`FILEPATH` is your new file):
  ```
  reuse addheader --year 2022 --copyright="Fermi Research Alliance, LLC" \
    --license="Apache-2.0" --template=compact FILEPATH
  ```
- Files that are not supported and have no comments to add the SPDX notice
  can be added to the `.reuse/dep5` file
- New licenses can be added to the project using `reuse download LCENSEID`. Please
  contact project management if this is needed.
