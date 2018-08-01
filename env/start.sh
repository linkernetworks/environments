#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

# Exec the specified command or fall back on bash
if [ $# -eq 0 ]; then
    cmd=bash
else
    cmd=$*
fi

for f in /usr/local/bin/start-notebook.d/*; do
  case "$f" in
    *.sh)
      echo "$0: running $f"; . "$f"
      ;;
    *)
      if [ -x $f ]; then
        echo "$0: running $f"
        $f
      else
        echo "$0: ignoring $f"
      fi
      ;;
  esac
  echo
done

# Execute the command
echo "Executing the command: $cmd"
exec $cmd --allow-root
