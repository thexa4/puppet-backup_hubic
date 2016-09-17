class backup_hubic(
  $client_id,
  $client_secret,
  $secret_host,
  $ca = '/etc/ssl/certs/host-ca.crt',
  $cert = '/etc/ssl/certs/host.crt',
  $key = '/etc/ssl/private/host.key',
){

  include ::backup

  if (!defined(File['/opt/max'])) {
    file { '/opt/max':
      ensure => directory,
    }
  }

  file { '/opt/max/backup':
    ensure  => directory,
    require => File['/opt/max/'],
  }

  file { '/opt/max/backup/fetch_credentials':
    ensure  => file,
    content => epp('backup_hubic/fetch_credentials.epp', {
      'client_id'     => $client_id,
      'client_secret' => $client_secret
    }),
    mode    => '0700',
    require => File['/opt/max/backup'],
  }

  exec { 'fetch hubic auth key':
    creates => '/etc/duply/default/hubic.auth',
    command => "/usr/bin/wget --ca-certificate=\"${ca}\" --certificate=\"${cert}\" --private-key=\"${key}\" https://${secret_host}/hubic --output-document=/etc/duply/default/hubic.auth && /opt/max/backup/fetch_credentials \$(cat /etc/duply/default/hubic.auth) || (rm /etc/duply/default/hubic.auth && exit 1)",
    require => [
      File[$ca],
      File[$cert],
      File[$key],
      File['/etc/duply/default'],
      File['/opt/max/backup/fetch_credentials'],
    ],
  }

  file { '/usr/lib/python2.7/dist-packages/duplicity/backends/hubicbackend.py':
    ensure  => file,
    source  => 'puppet:///modules/backup_hubic/hubicbackend.py',
    require => Package['duply'],
  }

  package { 'python-swiftclient':
    ensure => installed,
  }
}
