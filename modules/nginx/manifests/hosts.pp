class nginx::hosts($servername) {


	file { ["/etc/hosts"]:
	    content => template('nginx/hosts.erb'),
	}
}
