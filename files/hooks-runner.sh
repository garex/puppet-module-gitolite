#!/usr/bin/env bash

hookName=$(basename $0)
hookPathStart=$GL_ADMIN_BASE/hooks/common/.generated/$hookName
commonScope=$hookPathStart.common.*
repositoryScope=$hookPathStart.repository.$(echo $GL_REPO | sed "s/\//-/g").*

for hook in $(ls -1 $commonScope $repositoryScope)
do
  . $hook
done
