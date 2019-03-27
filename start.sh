#!/bin/sh
#
# Author:  PingX<admin AT pingx.cc>
# Blog:  //blog.pingx.cc
#
# Upload openstack images, create tenants.



echo "
1)image upload.
2)Creat users"
	  
read -p "Selection option:" optionone
	if [ $optionone == "1" ];
	then
                echo " Please pyt the mirror in the Linux / directory and name the CentOS image as the centos7.qcow2 Server2008 image named win2008.qcow2 SDN image named odl.qcow2"
		echo "1) all images
2) ODL images
3) Centos7 image
4) Windows Server2008 image"
		read -p "Selection option" optiontwo
			if [ $optiontwo == "1" ];
			then
#二次选择开始
        source /root/openrc
        cd /

        centosid=$(glance image-create --name Centos7 --is-public true --container-format=bare --disk-format=qcow2 --min-ram=1024 --property architecture=x86_64 --property os_distro=Centos --property os_version=7 --property vol_size=50 --file centos7.qcow2        | grep id  | grep -o -E "........-....-....-....-............" )

        cinder create --image-id   $centosid   --display-name Centos7 50  --metadata awcloud_public_image=yes

        echo "centos mirros are being generated"

        server2008id=$(glance image-create --name Server2008 --is-public true --container-format=bare --disk-format=qcow2 --min-ram=1024 --property architecture=x86_64 --property os_distro=Server --property os_version=2008 --property vol_size=50 --file win2008.qcow2 | grep id  | grep -o -E "........-....-....-....-............" )

        cinder create --image-id   $server2008id   --display-name Server 50  --metadata awcloud_public_image=yes
        echo "Server mirros are being generated"

        sdnid=$(glance image-create --name SDN --is-public true --container-format=bare --disk-format=qcow2 --min-ram=1024 --property architecture=x86_64 --property os_distro=SDN --property os_version=1 --property vol_size=50 --file odl.qcow2 | grep id  | grep -o -E "........-....-....-....-............" )

        cinder create --image-id   $sdnid   --display-name SDN 50  --metadata awcloud_public_image=yes
        echo "ODL mirros are being generated"
	#全部选项 上传全部镜像
	elif [ $optiontwo == "2" ];
	then
        source /root/openrc
        cd /
	sdnid=$(glance image-create --name SDN --is-public true --container-format=bare --disk-format=qcow2 --min-ram=1024 --property architecture=x86_64 --property os_distro=SDN --property os_version=1 --property vol_size=50 --file odl.qcow2 | grep id  | grep -o -E "........-....-....-....-............" )
        cinder create --image-id   $sdnid   --display-name SDN 50  --metadata awcloud_public_image=yes
        echo "ODL mirros are being generated"
	elif [ $optiontwo == "3" ];
	then
        source /root/openrc
        cd /
	centosid=$(glance image-create --name Centos7 --is-public true --container-format=bare --disk-format=qcow2 --min-ram=1024 --property architecture=x86_64 --property os_distro=Centos --property os_version=7 --property vol_size=50 --file centos7.qcow2        | grep id  | grep -o -E "........-....-....-....-............" )
        cinder create --image-id   $centosid   --display-name Centos7 50  --metadata awcloud_public_image=yes
        echo "centos mirros are being generated"
        elif [ $optiontwo == "4" ];
        then
        source /root/openrc
        cd /
	server2008id=$(glance image-create --name Server2008 --is-public true --container-format=bare --disk-format=qcow2 --min-ram=1024 --property architecture=x86_64 --property os_distro=Server --property os_version=2008 --property vol_size=50 --file win2008.qcow2 | grep id  | grep -o -E "........-....-....-....-............" )
        cinder create --image-id   $server2008id   --display-name Server 50  --metadata awcloud_public_image=yes
        echo "Server mirros are being generated"
	else 
		echo "select error"
	fi
elif [ $optionone == "2" ];
then
source /root/openrc
	read -p "Create a project:(default:student)" project
	if [ ! -n "$project" ];
then
	source /root/openrc
	project=student
        keystone tenant-create --name $project --description test --enabled true
else
	source /root/openrc
        keystone tenant-create --name $project --description test --enabled true

fi
	
read -p "How many users do you create?" frequency
for ((i=1;i<=$frequency;i++))
do
	source /root/openrc
        read -p "enter user name:" user1
        read -p "enter user password:" password1
        keystone user-create --name $user1 --pass $password1
        keystone user-role-add --user $user1 --role admin --tenant $project
done

else echo "bye~"
fi
