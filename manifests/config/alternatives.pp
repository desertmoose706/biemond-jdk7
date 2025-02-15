#
# java alternatives for rhel, debian
#
define jdk7::config::alternatives(
  $java_home_dir  = undef,
  $full_version   = undef,
  $priority       = undef,
  $user           = undef,
  $group          = undef,
)
{
  case $::osfamily {
    'RedHat': {
      $alt_command = 'alternatives'
    }
    'Debian', 'Suse':{
      $alt_command = 'update-alternatives'
    }
    default: {
      fail("Unrecognized osfamily ${::osfamily}, please use it on a Linux host")
    }
  }

  if $title == 'java_sdk' {
    exec { "java alternatives ${title}":
      command   => "${alt_command} --install /etc/alternatives/${title} ${title} ${java_home_dir}/${full_version}/bin/${title} ${priority};${alt_command} --set ${title} ${java_home_dir}/${full_version}/bin/${title}",
      unless    => "${alt_command} --display ${title} | /bin/grep 'link currently' | /bin/grep ${full_version}",
      path      => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin',
      logoutput => true,
      user      => $user,
      group     => $group,
    }
  }
  else {
    exec { "java alternatives ${title}":
      command   => "${alt_command} --install /usr/bin/${title} ${title} ${java_home_dir}/${full_version}/bin/${title} ${priority};${alt_command} --set ${title} ${java_home_dir}/${full_version}/bin/${title}",
      unless    => "${alt_command} --display ${title} | /bin/grep 'link currently' | /bin/grep ${full_version}",
      path      => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin',
      logoutput => true,
      loglevel  => verbose,
      user      => $user,
      group     => $group,
    }
  }
}
