#!/bin/bash

if [[ ! -z "${JUPYTER_PASSWORD_HASH}" ]]; then
  jupyter lab --NotebookApp.token='' --NotebookApp.password='${JUPYTER_PASSWORD_HASH}' --notebook-dir='~/notebook/work' --config='~/notebook/.jupyter/jupyter_notebook_config.py'
elif [[ "${JUPYTER_NO_PASSWORD}" == "true" ]]; then
  jupyter lab --NotebookApp.token='' --NotebookApp.password='' --notebook-dir='~/notebook/work' --config='~/notebook/.jupyter/jupyter_notebook_config.py'
else
  jupyter lab --NotebookApp.token='' --notebook-dir='~/notebook/work' --config='~/notebook/.jupyter/jupyter_notebook_config.py'
fi
