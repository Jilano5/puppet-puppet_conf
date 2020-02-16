# Provider: puppet_conf

Puppet::Type.type(:puppet_conf).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:ruby),
) do
  def section
    resource[:name].split('/', 2).first
  end

  def setting
    resource[:name].split('/', 2).last
  end

  def self.file_path
    Puppet.settings['config']
  end
end

# vim: ts=2 sw=2 et
