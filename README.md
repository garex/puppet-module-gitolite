# Puppet module for adding gitolite management

Manage gitolite instance with minimal possible dependencies. Can add hooks to repos: both for all repos and individually.

## Description

Module adds gitolite role to node and *only* gitolite without gitweb and other stuff, that can be added independently.

All you need is public key contents, that used during setup.

You can have any hooks you want -- they all run in parallel.

### Dependencies

Same as gitolite:

* sh
* git 1.6.6+
* perl 5.8.8+
* openssh 5.0+
* gitolite 3.0+

### Implementation notes

Currently we use for install direct git cloning -- not packages, as they are buggy (see debian for example).

## Usage

### Add gitolite support

```ruby

    class {"gitolite":
      public_key_content  => "ssh-rsa ... = blabla-openssh-key",

      # Defaults
      user                => "gitolite",
      group               => "gitolite",
      home                => "/home/gitolite",
    }

```

### Add hook to all repos

```ruby

    gitolite::hook {"Doing something on all repos at post-receive":
      type        => "post-receive",
      content     => "touch ~/i-am-post-receive-on-all-repos",
    }

```

### Add hook to concrete repo

```ruby

    gitolite::hook {"Doing something in testing repo at post-receive":
      type        => "post-receive",
      content     => "touch ~/i-am-post-receive-in-testing-repo",
      repository  => "testing",
    }

```

## How to check that install was ok?

From unix:

    ssh gitolite@gitolite.host info

From windows:

    plink gitolite@gitolite.host info
