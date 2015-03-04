exec { 'apt-get update' :
	command => '/usr/bin/apt-get update',
	timeout => 0
}

package { 'wget':
	ensure => present,
	require => Exec['apt-get update']
}

package { 'openssh-server':
	ensure => present,
	require => Exec['apt-get update']
}

package { 'postfix':
	ensure => present,
	require => Exec['apt-get update']
}

$omnibus = "gitlab_7.8.1-omnibus-1_amd64.deb"

exec { 'wget omnibus' :
	command => "/usr/bin/wget https://downloads-packages.s3.amazonaws.com/ubuntu-14.04/${omnibus} -O /tmp/${omnibus}",
	unless  => "/usr/bin/test -f /tmp/${omnibus}",
	require => [ Package["wget"] ],
	timeout => 0
}

exec { 'dpkg -i omnibus' :
	command => "/usr/bin/dpkg -i /tmp/${omnibus}",
	require => [ Exec["wget omnibus"], Package["postfix"], Package[openssh-server] ]
}