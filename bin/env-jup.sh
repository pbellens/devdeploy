#!/bin/bash

# https://stackoverflow.com/questions/47295871/is-there-a-way-to-use-pipenv-with-jupyter-notebook
# I assume where in the root of the pipenv project
pipenv install ipykernel
pipenv run python -m ipykernel install --user --name=my-virtualenv-name
pipenv run jupyter notebook
