class nginx::systeminfo{

	

 $systeminfodata = [
  {
        metric => $::puppetversion,
        description => "Puppet Version"
  },
  {
        metric => $::rubyplatform,
        description => "Ruby Platform"
  },
  {
	metric => $::kernelmajversion,
	description => "Kernel Major Version"
  },
  {
	metric => $::kernelrelease,
	description => "Kernel Release"
  }
 ]

}
