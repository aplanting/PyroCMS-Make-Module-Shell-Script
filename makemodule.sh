#!/bin/bash
# created by A. Planting 
# http://www.life-blog.nl/blog/2011/06/06/pyrocms-the-structure-of-an-module
#
echo '###########################################################################'
echo ' Directly in the root of your Pyrocms install there is an folder called'
echo ' addons which contains the third party modules.'
echo ' Just copy in the full path to the root of your Pyrocms install'
echo ' usually it can be found at /var/www or /var/www/pyrocms'
echo '###########################################################################'
read folder
	
echo '###########################################################################'	
echo 'Give your module an sensible name.'
echo 'Be sure to check if it doesnot exist already!'
echo 'The script will check the name in the module folder anyway :-)'
echo '###########################################################################'	
read modulenaam

# change to the pyrocms directory
cd $folder
if [ -d $modulenaam ]; then
	echo 'Module-folder already exists'
	#exit
else
	mkdir $modulenaam
fi

echo '###########################################################################'
echo 'The admin menu has an section content. The link to your module will'
echo 'appear under content if you do not set an option here'	
echo 'The value you set here will be used as menu name and appears'
echo 'in details.php as menu => your_value'
echo 'so leave blank for content'
echo '###########################################################################'	
read adminmenu

if [ -z "$adminmenu" ]; then
	adminmenu1='content'
else
	adminmenu1=$adminmenu
fi
 
# change to the module direcory
cd $modulenaam
# now make the folder structure, array of folder names
folders=('controllers config css img js language models views views/admin')
elements=${folders[@]}
	
	for foldername in $elements
		do
			mkdir $foldername
		done


# details.php file is created first. It contains informatie about the module
# and it creates the database structure for instance on install.

	if [ -e 'details.php' ]; then
		
		echo 'details.php already exists'

	else

cat > $folder'/'$modulenaam'/details.php' << EOF
<?php defined('BASEPATH') or exit('No direct script access allowed');

   class Module_$modulenaam extends Module {

	public \$version  = '1.0';

	public function info()
	{
		return array(
			'name' => array(
				'en' => '$modulenaam'
			),
			'description' => array(
				'en' => 'This is a PyroCMS module template.'
			),
			'frontend' => TRUE,
			'backend' => TRUE,
			'menu' => '$adminmenu1'
		);
	}
	
	public function install()
	{
		return TRUE;
	}
	
	public function uninstall()
	{
		return TRUE;
	}
	
	public function upgrade(\$old_version)
	{
		return TRUE;
	}
	
	public function help()
	{
		return "there is no help for this module for now";
	}

   }
EOF
fi

# make admin file in controllers
cd 'controllers/'

	if [ -e 'admin.php' ]; then
		
		echo 'admin.php already exists'
	
	else
		
cat > 'admin.php' << EOF
<?php defined('BASEPATH') or exit('No direct script access allowed');
	
	class Admin extends Admin_Controller
	{
		public \$id = 0;
		
		public function __construct()
		{
			parent::__construct();
			// Load all the required classes
			\$this->template->append_metadata(css('admin.css', '$modulenaam'));
		
		}
		
		public function index()
		{
				\$this->template->build('admin/index');
		}
		
		// now you can start en build your own functions
	}
EOF
fi

# make Front End file in controllers

	if [ -e ''$modulenaam'.php' ] ; then
	
		echo ''$modulenaam'.php already exists'
	
	else
		
cat > $modulenaam'.php' << EOF
<?php defined('BASEPATH') or exit('No direct script access allowed');

class $modulenaam extends Public_Controller
{
	public function __construct()
	{
		parent::__construct();
		// Load the required classes
	}

	public function index()
	{
		\$this->template->title('This is an example')->build('index','');				
	}
}

EOF
	fi	


# build the default admin view
# 
cd '../views/admin/'
	if [ -e 'index.php' ]; then
		echo 'view index.php bestaat al'
	
	else
		
cat > 'index.php' << EOF
<h2> Default admin template </h2>
EOF
fi


# build the default front end view
cd '../'
	if [ -e 'index.php' ]; then
		echo 'front end view index.php already exists'
	else
cat > 'index.php' << EOF
<div class="sample-container">
	<div class="inventory-data">
		This is an front end example view
	</div>
</div>
EOF
fi


#build the default css files, empty
cd '../css/'
	if [ -e 'admin.css' ]; then
		echo 'admin css file bestaat al'
	
	else
		
cat > 'admin.css' << EOF
h2 { color: #FF0000; }
EOF
fi

	if [ -e ''$modulenaam'.css' ]; then
		echo ''$modulenaam'.css bestaat al'
	else
cat > $modulenaam'.css' << EOF
h2 { color: #FF0000; }
EOF
fi

# end of script
echo '###########################################################################'	
echo 'module template has been created, you can now start develloping'
echo '###########################################################################'	
exit 0
