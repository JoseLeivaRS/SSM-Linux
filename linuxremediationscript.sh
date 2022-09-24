#!/bin/bash
detect_distro(){
  DISTRO=$( ( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1| grep -Poi '(debian|ubuntu|red hat|centos|suse|oracle)' | uniq )
if [ -z $DISTRO ]; then
    DISTRO='unknown'
fi
echo $DISTRO  #work on fixing this 
}
detect_distro 
install_ssm(){
  sudo curl -sL https://add-ons.manage.rackspace.com/bootstrap/azure/ssm_install.sh --output /tmp/ssm_install.sh  
  #INSTALLOUTPUT=$( chmod +x /tmp/ssm_install.sh; sudo sh -s /tmp/ssm_install.sh )
  # chmod +x /tmp/ssm_install.sh; sudo sh -s /tmp/ssm_install.sh
 # echo $INSTALLOUTPUT
  sudo /bin/bash /tmp/ssm_install.sh
}

uninstall_ssm(){
  case $RunningDistro in 
    Centos )
    echo running Centos .... Uninstalling
      sudo yum erase amazon-ssm-agent --assumeyes
    ;;
    Ubuntu )
    echo Running Ubuntu .... Uninstalling
    sudo dpkg -r amazon-ssm-agent
    ;;
    * )
    not recognized
    ;;
esac
}
get_status(){

}
REGION="us-west-2"
SSMEndPT=("ssm.$REGION.amazonaws.com" "ssmmessages.$REGION.amazonaws.com" "ec2messages.$REGION.amazonaws.com" "s3.$REGION.amazonaws.com" "add-ons.api.manage.rackspace.com" "add-ons.manage.rackspace.com")
#TEST=@()
#TESTOUTPUT=""

for URL in ${SSMEndPT[@]}
 do
    TEST=$(nc -vz $URL 443)
    #$TESTOUTPUT="$TEST"

    #echo $URL
done

insta

sudo systemctl status amazon-ssm-agent

amazon-ssm-agent -register -clear



#Region List git: https://github.com/RSS-Engineering/platform-services-common/blob/main/platform_services_common/common/region.py
 


# Notes and samples
:'

DB_AWS_ZONE=('us-east-2a' 'us-west-1a' 'eu-central-1a')
 
for zone in "${DB_AWS_ZONE[@]}"
do
  echo "Creating rds (DB) server in $zone, please wait ..."

done


40.124.181.96

'