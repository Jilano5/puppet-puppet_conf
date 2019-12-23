# Manage puppet.conf

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with puppet_conf](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppet_conf](#beginning-with-puppet_conf)
3. [Usage - Configuration options and additional functionality](#usage)
    * [puppet_conf resource type](#puppet_conf-resource-type)
    * [puppet_conf class](#puppet_conf-class)
    * [Examples](#examples)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Licensing information](#license)

## Description

This Puppet module provides a `puppet_conf` resource type for managing the `puppet.conf` configuration file on a per-entry basis.

The module also supplies a `puppet_conf` class for convenient Hiera-based management of Puppet configuration across infrastructure.

## Setup

### Setup Requirements

This module depends on the [puppetlabs/inifile](https://forge.puppet.com/puppetlabs/inifile) module.

### Beginning with puppet_conf

The `puppet_conf` type operates on the configuration file determined by the `puppet_config` fact.

The following example manages a `runinterval` entry of value `15m` in the `[agent]` section:

```puppet
puppet_conf { 'agent/runinterval':
  value => '15m',
}
```

## Usage

### puppet_conf resource type

The `puppet_conf` resource type has three attributes:

* `name` (namevar) &ndash; setting to manage, in `section/setting` notation;
* `ensure` (default: `present`) &ndash; manages a setting as `present` or `absent`;
* `value` &ndash; value for the setting; if set to `undef`, the behavior is to remove the setting.

This resource type may serve as an example of implementing a child provider as described in documentation to the [puppetlabs/inifile](https://forge.puppet.com/puppetlabs/inifile) module.

### puppet_conf class

The `puppet_conf` class has two attributes:

* `purge_unmanaged` (default: `false`) &ndash; purge unmanaged entries from `puppet.conf`;
* `entries` (default: `{}`) &ndash; hash of section-keyed setting-value hashes; use `undef` (`null` or `~` in Hiera) for a value to remove a setting.

Please look at the last two examples below to get a visual idea of what the `entries` hash would look like.

### Examples

Remember the last used environment:

```puppet
puppet_conf { 'main/environment':
  value => $server_facts['environment'],
}
```

Remove a configuration entry:

```puppet
puppet_conf { 'main/static_catalogs':
  ensure => absent,
}
```

Purge all settings not explicitly managed by Puppet:

```puppet
resources { 'puppet_conf':
  purge => true,
}
```

Manage several settings in different sections via the helper class using a nested hash:

```puppet
class { 'puppet_conf':
  entries => {
    'main'  => {
      'environment'      => 'production',
      'strict_variables' => true,
    },
    'agent' => {
      'certname'    => 'example.com',
      'runinterval' => '15m',
    },
  },
}
```

Store complete Puppet configuration in Hiera with deep merging (relevant parts only):

```puppet
# manifests/site.pp - entryway manifest

hiera_include('classes')
```
```yaml
# common.yaml - Hiera top-level settings

classes:
  - puppet_conf

lookup_options:
  puppet_conf::entries:
    merge:
      strategy: deep

puppet_conf::purge_unmanaged: true
puppet_conf::entries:
  main:
    server: puppet.example.com
    environment: production
    strict_variables: true
  agent:
    certname: "%{::trusted.certname}"
    runinterval: 15m
```
```yaml
# nodes/dev.yaml - node-specific settings

# deep merge strategy will override the corresponding
# environment setting from the top-level common.yaml
# (given that per-node configurations take precedence)
puppet_conf::entries:
  main:
    environment: development
```

## Limitations

The `puppet_conf` resource type is a thin syntactic sugar wrapper around the `ini_setting` type; all of its limitations and incompatibilities apply.

## License

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
