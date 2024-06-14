# Class: libvirt
#
# Install, enable and configure libvirt.
#
# Parameters
#
# General Parameters:
#  $defaultnetwork:
#    Whether the default network for NAT should be enabled. Default: false
#  $networks:
#    Hash of networks to define. This is in the format:
#      {
#        'network1' => {...},
#        'network2' => {...},
#        ...
#      }
#    Default: {}
#  $network_defaults:
#    Default values for all networks. Default: {}
#  $qemu:
#    Install the qemu-kvm package, required for KVM. Default: true
#  $libvirt_package,
#  $libvirt_service:
#    Package and service name for libvirtd. Defaults: system specific
#  $virtinst:
#    Install the python-virtinst package, to get virt-install. Default: true
#  $virtinst_package:
#    Package to install for virtinst. Default: system specific
#  $radvd:
#    Install the radvd package. Default: false
#  $radvd_package:
#    Package to install for radvd. Default: system specific
#
# Libvirtd Configuration:
#  $listen_tls:
#    Whether libvirtd should listen for TLS traffic. This requires additional
#    configuration, including providing appropriately set up TLS certificats.
#    Default: false
#  $listen_tcp:
#    Whether libvirtd should listen for plain TCP traffic. Default: false
#  $tls_port:
#    Port to listen for TLS traffic on. Default: 16514
#  $tcp_port:
#    Port to listen for plain TCP traffic on. Default: 16509
#  $listen_addr:
#    Optional IP address to listen on (applies to both TLS and TCP traffic).
#    If not set libvirtd will not listen for network connections (local Unix
#    sockets will still be supported).
#    Default: not set
#  $mdns_adv:
#    Whether to advertise the libvirt service via mDNS. Default: false
#  $auth_unix_ro:
#    Authentication mechanism to use for read-only Unix sockets.
#    Default: 'none'
#  $auth_unix_rw:
#    Authentication mechanism to use for read/write Unix sockets.
#    Default: 'none'
#  $auth_tcp:
#    Authentication mechanism to use for connections via TCP. If set to 'non',
#    the default, no authentication is used - in most real-world cases this
#    should be set to 'sasl', and SASL should be configured appropriately.
#    Default: 'none'
#  $auth_tls:
#    Authentication mechanism to use for TLS connections. TLS provides limited
#    authentication via certificates, however it is possible to use SASL for
#    additional authentication.
#    Default: none
#  $unix_sock_dir,
#  $unix_sock_group,
#  $unix_sock_ro_perms,
#  $unix_sock_rw_perms,
#  $unix_sock_admin_perms:
#    Options for the location and access controls for libvirtd's Unix sockets.
#    In most cases these may be left with their defaults.
#
# Systemd unit file configuration
#  $libvirtd_args:
#    Optional array of arguments to be passed to libvirtd on startup.
#    Default: []
#  $libvirtd_env:
#    Optional hash of KEY=VALUE pairs, which will be added to the libvirtd
#    startup environment.
#    Default: {}
#  $deb_default:
#    Optional hash of additional settings to be added to the debian defaults
#    file.
#    Default: { libvirtd_opts => '' }
#  $sysconfig:
#    Optional hash of additional settings for the sysconfig/libvirtd file.
#    Default: {}
#
# qemu Configuration:
#  $qemu_vnc_listen:
#    Listen address for qemu VNC servers. Default: 127.0.0.1
#  $qemu_vnc_sasl:
#    Whether to configure SASL authentication for qemu VNC servers.
#    Default: false
#  $qemu_vnc_tls:
#    Whether to configure TLS for qemu VNC servers. This requires additional
#    configuration, including providing TLS certificates.
#    Default: false
#  $qemu_set_process_name:
#    Whether qemu should set the process name to 'qemu:VM_NAME'. If this is
#    not set, the process name will be left as-is.
#    Default: false
#  $qemu_user:
#    Optional user that qemu will run as. Default: not set
#  $qemu_group:
#    Optional group that qemu will run as. Default: not set
#
# SASL Configuration:
#  $sasl2_libvirt_mech_list:
#    List of SASL authentication mechanisms libvirt should use. Has no effect
#    if SASL authentication is not enabled.
#    Default: 'digest-md5'
#  $sasl2_libvirt_sasldb:
#    Location of the SASL password database that libvirt should use (for
#    username/password auth mechanisms, including 'digest-md5').
#    Default: '/etc/libvirt/passwd.db'
#  $sasl2_libvirt_keytab:
#    Location of the kerberos keytab file libvirt should use.
#    Default: '/etc/libvirt/krb5.tab'
#  $sasl2_qemu_mech_list:
#    List of SASL auth mechanisms qemu should use. Has no effect if SASL auth
#    is not enabled.
#    Deafult: 'digest-md5'
#  $sasl2_qemu_sasldb:
#    Location of the SASL password database that qemu should use (for
#    username/password auth mechanisms, including 'digest-md5').
#    Default: '/etc/qemu/passwd.db'
#  $sasl2_qemu_keytab:
#    Location of the kerberos keytab file that qemu should use.
#    Default: '/etc/qemu/krb5.tab'
#  $sasl2_qemu_auxprop_plugin:
#    Auxiliary property plugin for qemu to use. Has no effect if SASL auth is
#    not enabled.
#    Default: 'sasldb'
#
# Deprecated Paramters
#  $deb_default
#  $sysconfig
# Sample Usage :
#  include libvirt
#
class libvirt (
  Boolean $defaultnetwork      = false,
  Hash[String, Any] $networks  = {},
  Hash[String, Any] $networks_defaults = {},
  Boolean $qemu                = true,
  String $libvirt_package      = $libvirt::params::libvirt_package,
  String $libvirt_service      = $libvirt::params::libvirt_service,
  Boolean $virtinst            = true,
  String $virtinst_package     = $libvirt::params::virtinst_package,
  Boolean $radvd               = false,
  String $radvd_package        = $libvirt::params::radvd_package,
  # libvirtd.conf options
  Boolean $listen_tls          = false,
  Boolean $listen_tcp          = false,
  Integer $tls_port            = 16514,
  Integer $tcp_port            = 16509,
  Optional[String] $listen_addr = undef,
  Boolean $mdns_adv            = false,
  String $auth_unix_ro         = 'none',
  String $auth_unix_rw         = 'none',
  String $auth_tcp             = 'none',
  String $auth_tls             = 'none',
  Optional[String] $unix_sock_dir = $libvirt::params::unix_sock_dir,
  Optional[String] $unix_sock_group = $libvirt::params::unix_sock_group,
  Optional[String] $unix_sock_ro_perms = $libvirt::params::unix_sock_ro_perms,
  Optional[String] $unix_sock_rw_perms = $libvirt::params::unix_sock_rw_perms,
  Optional[String] $unix_sock_admin_perms = $libvirt::params::unix_sock_admin_perms,
  # systemd service configuration
  Array[String] $libvirtd_args = $libvirt::params::libvirtd_args,
  Hash[String, String] $libvirtd_env = $libvirt::params::libvirtd_env,
  # qemu.conf options
  String $qemu_vnc_listen      = '127.0.0.1',
  Boolean $qemu_vnc_sasl       = false,
  Boolean $qemu_vnc_tls        = false,
  Boolean $qemu_set_process_name = false,
  Optional[String] $qemu_user  = undef,
  Optional[String] $qemu_group = undef,
  # sasl2 options
  String $sasl2_libvirt_mech_list = 'digest-md5',
  String $sasl2_libvirt_sasldb = '/etc/libvirt/passwd.db',
  String $sasl2_libvirt_keytab = '/etc/libvirt/krb5.tab',
  String $sasl2_qemu_mech_list = 'digest-md5',
  String $sasl2_qemu_sasldb    = '/etc/qemu/passwd.db',
  String $sasl2_qemu_keytab    = '/etc/qemu/krb5.tab',
  String $sasl2_qemu_auxprop_plugin = 'sasldb',
  # deprecated
  $deb_default = undef,
  $sysconfig = undef,
) inherits ::libvirt::params {

  if $deb_default {
    warning("The deb_default paramter is no longer supported!")
    warning("Service configuration has been consolidated under libvirtd_args and libvirtd_env.")
  }
  if $sysconfig {
    warning("The sysconfig paramter is no longer supported!")
    warning("Service configuration has been consolidated under libvirtd_args and libvirtd_env.")
  } 

  package { 'libvirt':
    ensure => installed,
    name   => $libvirt::params::libvirt_package,
    tag    => 'libvirt',
  }

  service { 'libvirtd':
    ensure    => running,
    name      => $libvirt::params::libvirt_service,
    enable    => true,
    hasstatus => true,
    tag       => 'libvirt',
  }

  file { '/etc/libvirt/libvirtd.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('libvirt/libvirtd.conf.erb'),
    notify  => Service['libvirtd'],
    tag     => 'libvirt',
  }

  file { '/etc/libvirt/qemu.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('libvirt/qemu.conf.erb'),
    notify  => Service['libvirtd'],
    tag     => 'libvirt',
  }

  file { '/etc/sasl2/libvirt.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('libvirt/sasl2/libvirt.conf.erb'),
    notify  => Service['libvirtd'],
    tag     => 'libvirt',
  }

  # The default network, automatically configured... disable it by default
  $def_net = $defaultnetwork? {
    true    => 'enabled',
    default => 'absent',
  }
  libvirt::network { 'default':
    ensure       => $def_net,
    autostart    => true,
    forward_mode => 'nat',
    bridge       => 'virbr0',
    ip           => [ $::libvirt::params::default_ip ],
  }

  # The most useful libvirt-related packages
  if $virtinst {
    package { $libvirt::params::virtinst_package:
      ensure => installed,
      tag    => 'libvirt',
    }
  }
  if $qemu {
    package { 'qemu-kvm':
      ensure => installed,
      tag    => 'libvirt',
    }
    file { '/etc/sasl2/qemu-kvm.conf':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('libvirt/sasl2/qemu-kvm.conf.erb'),
      notify  => Service['libvirtd'],
      tag     => 'libvirt',
    }
  }
  if $radvd {
    package { $libvirt::params::radvd_package:
      ensure => installed,
      tag    => 'libvirt',
    }
  }

  # Optional changes to the sysconfig file (on RedHat), or the defaults file
  $args_env_var = $libvirt::params::args_env_var
  file { 'defaults_file':
    path    => $libvirt::params::defaults_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($libvirt::params::defaults_template),
    notify  => Service['libvirtd'],
    tag     => 'libvirt',
  }

  # Ensure all the configuration is set before starting the service
  Package <| tag == 'libvirt' |>
  -> File <| tag == 'libvirt' |>
  -> Service <| tag == 'libvirt' |>

  # Create Optional networks
  create_resources(libvirt::network, $networks, $networks_defaults)

}
