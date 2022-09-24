#!/bin/bash
detect_distro(){
  DISTRO=$( ( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1| grep -Poi '(debian|ubuntu|red hat|centos|suse|oracle)' | uniq )
  if [ -z $DISTRO ]; then
    DISTRO='unknown'
  fi
  echo $DISTRO
}


## Functions Install, Uninstall, get Status, test AWS Endpoints **Region is static **

install_ssm(){
  #Saves script into /tmp/ directory
  sudo curl -sL https://add-ons.manage.rackspace.com/bootstrap/azure/ssm_install.sh --output /tmp/ssm_install.sh  

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
  case $RunningDistro in
  Centos )
  echo Running $RunningDistro ... Checking status
    sudo systemctl status --no-pager amazon-ssm-agent
  ;;
  Ubuntu )
  echo Running $RunningDistro ... Checking status
    sudo systemctl status --no-pager amazon-ssm-agent
  ;;
  * )
  not recognized
  ;;
esac
}

REGION="us-west-2"
test_endpoints() {
  SSMEndPT=("ssm.$REGION.amazonaws.com" "ssmmessages.$REGION.amazonaws.com" "ec2messages.$REGION.amazonaws.com" "s3.$REGION.amazonaws.com" "add-ons.api.manage.rackspace.com" "add-ons.manage.rackspace.com")
  #TEST=@()
  #TESTOUTPUT=""

  for URL in ${SSMEndPT[@]}
  do
      TEST=$(nc -vz $URL 443)
      #$TESTOUTPUT="$TEST"

      #echo $URL
  done
}


#Logic will go here, these are place holders for testing , RunningDistro is set

#Detects VM's Linux Distro & saves to $RunningDistro Variable
RunningDistro=$(detect_distro)

get_status
test-test_endpoints
install_ssm
get_status
uninstall_ssm
echo ""