# Tabletop Club Documentation

The documentation is built using [Sphinx](https://www.sphinx-doc.org/en/master/).

## Requirements

To build the documentation, you will first need to create a Python virtual
environment so you can install packages without affecting your system:

```bash
python3 -m venv env
```

Then, activate the environment and install the necessary packages:

```bash
source env/bin/activate
pip3 install -r requirements.txt
```

Once you are done building the documentation, you can then use `deactivate` at
any time to exit out of the virtual environment:

```bash
deactivate
```

## Building

To build the documentation on macOS and Linux:
```bash
make html
```

To build the documentation on Windows:
```bash
make.bat html
```

You can then view the documentation by opening `_build/html/index.html` in the
web browser of your choice.

## Cleaning

To clean the build files on macOS and Linux:
```bash
make clean
```

To clean the build files on Windows:
```bash
make.bat clean
```
