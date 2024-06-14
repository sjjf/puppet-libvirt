# Class: libvirt::params
#
# Hold values for parameters and variables for each supported platform.
#
class libvirt::params {

  case $::facts['os']['family'] {
    'RedHat': {
      $libvirt_package = "libvirt.${facts['os']['architecture']}"
      $libvirt_service = 'libvirtd'
      if versioncmp($facts['os']['release']['major'], '7') >= 0 {
        $virtinst_package = 'virt-install'
      } else {
        $virtinst_package = 'python-virtinst'
      }
      $radvd_package = 'radvd'
      $sysconfig = {}
      $defaults_file = '/etc/sysconfig/libvirtd'
      $defaults_template = "${module_name}/sysconfig/libvirtd.erb"
      $deb_default = undef
      # these are just the defaults
      $unix_sock_dir = '/var/run/libvirt'
      $unix_sock_group = undef
      $unix_sock_ro_perms = undef
      $unix_sock_rw_perms = undef
      $unix_sock_admin_perms = undef
    }
    'Debian': {
      $virtinst_package = 'virtinst'
      $radvd_package = 'radvd'
      $sysconfig = undef
      case $facts['os']['distro']['codename'] {
        'bionic': {
          $libvirt_package = 'libvirt-daemon-system'
          $defaults_file = '/etc/default/libvirtd'
          $defaults_template = "${module_name}/default/libvirtd.erb"
        }
        default: {
          $libvirt_package = 'libvirt-bin'
          $defaults_file = '/etc/default/libvirt-bin'
          $defaults_template = "${module_name}/default/libvirt-bin.erb"
        }
      }
      # assume systemd, remove '-d'
      $deb_default = { 'libvirtd_opts' => '' }
      # UNIX socket
      $auth_unix_ro = 'none'
      $unix_sock_ro_perms = '0440'
      $unix_sock_rw_perms = '0770'
      $unix_sock_admin_perms = '0700'
      $unix_sock_dir = '/var/run/libvirt'
      $auth_unix_rw = 'none'
      case $facts['os']['name'] {
        'LinuxMint': {
          $libvirt_service = 'libvirt-bin'
          $unix_sock_group = 'libvirtd'
        }
        default: {
          $libvirt_service = 'libvirtd'
          $unix_sock_group = 'libvirt'
        }
      }
    }
    default: {
      $libvirt_package = 'libvirt'
      $libvirt_service = 'libvirtd'
      $virtinst_package = 'python-virtinst'
      $radvd_package = 'radvd'
      $sysconfig = undef
      $deb_default = undef
      # don't touch the defaults if we don't have platform specific knowledge
      $unix_sock_dir = undef
      $unix_sock_group = undef
      $unix_sock_ro_perms = undef
      $unix_sock_rw_perms = undef
      $unix_sock_admin_perms = undef
    }
  }

  $default_dhcp = {
    'start' => '192.168.122.2',
    'end'   => '192.168.122.254',
  }
  $default_ip = {
    'address' => '192.168.122.1',
    'netmask' => '255.255.255.0',
    'dhcp'    => $default_dhcp,
  }
}

