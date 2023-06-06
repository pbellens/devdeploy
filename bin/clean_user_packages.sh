#!/bin/bash

python -m pip freeze --user | xargs python -m pip uninstall -y
rm -rf $(poetry config virtualenvs.path)/*
