define gitolite::hook (
  $type,
  $content,
  $repository = undef
) {

  File {
    owner   => $gitolite::user,
    group   => $gitolite::group,
    ensure  => "present",
  }

  case $type {
    "applypatch-msg", "commit-msg", "post-commit", "post-receive", "post-update",
    "pre-applypatch", "pre-commit", "prepare-commit-msg", "pre-rebase": { }
    "update": { fail("Gitolite hook type $type is forbidden as it used in gitolite internally") }
    default:  { fail("Gitolite hook type $type is unknown") }
  }

  if ! defined(File["Gitolite hooks runner for type $type"]) {
    file {"Gitolite hooks runner for type $type":
      require   => File["Gitolite hooks autodirectory"],
      path      => "${gitolite::hooks_root}/$type",
      source    => "puppet:///modules/gitolite/hooks-runner.sh",
      mode      => 0755,
    }
  }

  $scope = $repository ? {
    undef   => "common",
    default => regsubst(regsubst("repository.${repository}", '\s+', '_', 'EG'), '/', '-', 'EG')
  }
  $hook_name = regsubst($name, '\s+', '_', 'EG')
  file {"Gitolite $type hook for $name":
    require => File["Gitolite hooks runner for type $type"],
    path    => "${gitolite::hooks_generated_root}/${type}.${scope}.${hook_name}",
    notify  => Exec["Apply gitolite hooks changes"],
    content => $content
  }

}