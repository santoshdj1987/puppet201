# Manage an Nginx virtual host
#class  nginx::vhost($domain='UNSET',$root='UNSET') {

class  nginx::vhost {
 
 $default_parent_root = "/home/ubuntu/nginxsites-puppet"
 $dir_tree = [ "$default_parent_root"]
 file { $dir_tree :
          owner   => 'ubuntu',
          group   => 'ubuntu',
          ensure  => 'directory',
         mode    => '777',
  }


 define apply( $domain="UNSET",$root="UNSET"){  
 
  include nginx  # Class was declared inside init.pp
  include nginx::hosts 
  # Default value overrides
 
  if $domain == 'UNSET' {
    $vhost_domain = $name
  } else {
    $vhost_domain = $domain
  }
 
  if $root == 'UNSET' {
    $vhost_root = "$default_parent_root/${name}"
  } else {
    $vhost_root = $root
  }
 
 
  # Creating the virtual host conf file out of the template in nginx/templates directory
 
  file { "/etc/nginx/sites-available/${vhost_domain}.conf":
    content => template('nginx/vhost.erb'), # vhost.erb is present in nginx/templates/
    require => Package['nginx'],
    notify  => Exec['reload nginx'], # Resource was declared in init.pp
  }
 
  # Enabling the site by creating a sym link from sites-available to sites-enabled
 
  file { "/etc/nginx/sites-enabled/${vhost_domain}.conf":
    ensure  => link,
    target  => "/etc/nginx/sites-available/${vhost_domain}.conf",
    require => File["/etc/nginx/sites-available/${vhost_domain}.conf"],
    notify  => Exec['reload nginx'],
  }
 
  addStaticFiles{ "staticfiles-${vhost_root}":
	default_parent_root =>  $default_parent_root, 
	vhost_root => $vhost_root,
	vhost_domain => $vhost_domain,
	
  } 


 }
 
 define addStaticFiles( $default_parent_root, $vhost_root , $vhost_domain ){

	# Creating the directory structure for the site directory
	# The array stores the directories to be created.
	# Puppet does not support a "mkdir -p " struct.
	# Hence, directories and subdirectories need to be
	# (painfully) defined in the puppet manifest, as below.

        include nginx::systeminfo	

 	 $dir_tree = [ "$vhost_root" ]
	 file { $dir_tree :
        	  owner   => 'ubuntu',
	          group   => 'ubuntu',
	          ensure  => 'directory',
	          mode    => '777',
 	  }
	  ->   # This arrow ensures that the dir structure is created first.
	  file {  ["$vhost_root/index.html"]:
       	     owner   => 'ubuntu',
	            group   => 'ubuntu',
	            source => "puppet:///modules/nginx/${vhost_domain}/index-html", # index.html was dropped under nginx/files/
        	    mode    => '755',
	  }->
	file { ["$vhost_root/systeminfo.html"] :
		content => template("nginx/systeminfo.erb"),
	}	
   }
}
