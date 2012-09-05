# Puppet module for adding gitolite management

Manage gitolite instance with minimal possible dependencies.

## Description

Module adds gitolite role to node and *only* gitolite without gitweb and other stuff, that can be added independently.

All you need is public key contents, that used during setup.

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

```ruby

    class {"gitolite":
      public_key_content  => "ssh-rsa ... = blabla-openssh-key",

      # Defaults
      user                => "gitolite",
      group               => "gitolite",
      home                => "/home/gitolite",
    }

```

## How to check that install was ok?

From unix:

    ssh gitolite@gitolite.host info

From windows:

    plink gitolite@gitolite.host info
