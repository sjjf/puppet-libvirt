# Class: libvirt::params
#
# Hold values for parameters and variables for each supported platform.
#
class libvirt::params {

  case $::osfamily {
    'RedHat': {
      $libvirt_package = "libvirt.${::architecture}"
      $libvirt_service = 'libvirtd'
      if versioncmp($::operatingsystemmajrelease, '7') >= 0 {
        $virtinst_package = 'virt-install'
      } else {
        $virtinst_package = 'python-virtinst'
      }
      $radvd_package = 'radvd'
      $sysconfig = {}
      $defaults_file = '/etc/sysconfig/libvirtd'
      $defaults_template = "${module_name}/sysconfig/libvirtd.erb"
      $deb_default = false
    }
    'Debian': {
      $virtinst_package = 'virtinst'
      $radvd_package = 'radvd'
      $sysconfig = false
      case $::lsbdistroname {
        'bionic': {
         $libvirt_package = 'libvirt-daemon-system'
         $defaults_file = '/etc/default/libvirtd'
         $defaults_template = "${modules_name}/devault/libvirtd.erb"
        }
        default: {
          $libvirt_package = 'libvirt-bin'
          $defaults_file = '/etc/default/libvirt-bin'
          $defaults_template = "${module_name}/default/libvirt-bin.erb"
        }
      }
      $deb_default = $::service_provider ? {
        'systemd' => { 'libvirtd_opts' => '' },  # no '-d', it confuses systemd
        default   => {},
      }
      # UNIX socket
      $auth_unix_ro = 'none'
      $unix_sock_ro_perms = 'none'
      $unix_sock_rw_perms = '0770'
      $unix_sock_admin_perms = '0700'
      $auth_unix_rw = 'none'
      case $::operatingsystem {
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
      $sysconfig = false
      $deb_default = false
      $unix_sock_dir = '/var/run/libvirt'
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

