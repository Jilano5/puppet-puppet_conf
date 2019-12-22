# @summary Manage puppet.conf
#
# Class for managing the puppet.conf file contents
#
# @example
#   include puppet_conf

class puppet_conf (
  Boolean $purge_unmanaged = false,
  Hash    $entries         = {},
) {
  if $purge_unmanaged {
    resources { 'puppet_conf':
      purge => true,
    }
  }

  $entries.each | $section, $settings | {
    $settings.each | $setting, $value | {
      $ensure = $value ? {
        undef   => absent,
        default => present,
      }

      puppet_conf { "${section}/${setting}":
        ensure => $ensure,
        value  => $value,
      }
    }
  }
}

# vim: ts=2 sw=2 et
