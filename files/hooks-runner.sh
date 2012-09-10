#!/usr/bin/env bash

hookName=$(basename $0)
hooksRoot=$GL_ADMIN_BASE/hooks/common/.generated
repositoryName=$(echo $GL_REPO | sed "s/\//-/g")
hookPattern="^$hookName\.(common|repository\.$repositoryName)\."

for hook in $(ls -1 $hooksRoot | egrep $hookPattern)
do
  echo "Hooking $hook"
  . $hooksRoot/$hook
done
