#node default {
 #    file {'/tmp/mastersetup-success':                                   # resource type file and filename
  #     ensure  => present,                                               # make sure it exists
   #    mode    => 0644,                                                  # file permissions
    #   content => "Here is my Public IP Address: ${ipaddress_eth0}.\n",  # note the ipaddress_eth0 fact
     #}
#}

node default {
        nginx::vhost::apply{ "web1":
                domain => "site1.puppet.santoshdj.in",
                root => "/home/ubuntu/site1"
        }
        nginx::vhost::apply{"web2":
                domain => "site2.puppet.santoshdj.in",
                root => "/home/ubuntu/site2"

        }

        $servers = [
                 {
                    ip_address => '127.0.0.1',
                    hostname   => 'site1.puppet.santoshdj.in'

                 },
                 {
                    ip_address  => '127.0.0.1',
                    hostname => 'site2.puppet.santoshdj.in'
                 },
        ]
        class { 'nginx::hosts':
                servername => $servers
        } 

# $var1 = hiera('domain_usage')
 #notice($var1)
}
