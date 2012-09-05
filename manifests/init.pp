class gitolite (
  $public_key_content,

  # Defaults
  $user   = "gitolite",
  $group  = "gitolite",
  $home   = "/home/gitolite"
) {

  group {"Add gitolite group":
    name    => $group,
  }

  user {"Add gitolite user":
    require => Group["Add gitolite group"],
    name    => $user,
    gid     => $group,
    home    => $home,
    comment => "Git repositories hosting management",
    shell   => "/bin/bash",
  }

  file {"Create gitolite home directory":
    require => User["Add gitolite user"],
    ensure  => "directory",
    group   => $group,
    owner   => $user,
    path    => $home,
  }

  file {"Set content of public key":
    require => File["Create gitolite home directory"],
    content => $public_key_content,
    group   => $group,
    owner   => $user,
    path    => "$home/gitolite.pub",
  }

  Package {
    ensure  => "latest"
  }

  if ! defined(Package["bash"]) {
    package {"bash":}
  }

  if ! defined(Package["perl"]) {
    package {"perl":
      require   => Package["bash"]
    }
  }

  import "osfamily"
  $ssh_package = $::osfamily ? {
    "Debian"  => "openssh-client",
    "RedHat"  => "openssh-clients",
    default   => "ssh-client"
  }
  $git_package = $::osfamily ? {
    "Debian"  => "git-core",
    default   => "git",
  }

  if ! defined(Package[$ssh_package]) {
    package {$ssh_package:
      require   => Package["bash"]
    }
  }

  if ! defined(Package[$git_package]) {
    package {$git_package:
      require   => Package[$ssh_package]
    }
  }

  exec {"Download gitolite":
    require => [Package[$git_package], File["Create gitolite home directory"]],
    cwd     => $home,
    command => "git clone git://github.com/sitaramc/gitolite src",
    creates => "$home/src",
    group   => $group,
    user    => $user,
  }

  exec {"Install gitolite":
    require => Exec["Download gitolite"],
    cwd     => "$home/src",
    command => "$home/src/install -ln /usr/bin",
    creates => "/usr/bin/gitolite",
  }

  exec {"Setup gitolite":
    require     => Exec["Install gitolite"],
    cwd         => $home,
    environment => "HOME=$home",
    command     => "/usr/bin/gitolite setup -pk $home/gitolite.pub",
    creates     => "$home/.gitolite",
    group       => $group,
    user        => $user,
  }

}
