# Type: puppet_conf

Puppet::Type.newtype(:puppet_conf) do
  ensurable

  newparam(:name, namevar: true) do
    desc 'Section/setting name to manage in puppet.conf'
    newvalues(%r{\S+\/\S+})
  end

  newproperty(:value) do
    desc 'The value of the setting to define'
    munge do |v|
      v.to_s.strip
    end
  end
end

# vim: ts=2 sw=2 et
