#!/bin/bash
jupyter notebook --allow-root --no-browser --ip="*" --notebook-dir="/batch" $*
