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
    echo -e "\nrunning Centos .... Uninstalling \n"
      sudo yum erase amazon-ssm-agent --assumeyes
    ;;
    Ubuntu )
    echo -e "\nRunning Ubuntu .... Uninstalling \n"
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
  echo -e "\nRunning $RunningDistro ... Checking status \n"
    sudo systemctl status --no-pager amazon-ssm-agent
  ;;
  Ubuntu )
  echo -e "\nRunning $RunningDistro ... Checking status \n"
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
  TESTOUTPUT=""

  for URL in ${SSMEndPT[@]}
  do
       if ! nc -vzw1 "${URL}" 443 ; then
       	TESTOUTPUT+="failed"$'\n'
       else
       	TESTOUTPUT+="succeeded"$'\n'
      fi
  done
}

get_ssmState() {
  SSMState=$(systemctl show -p ActiveState amazon-ssm-agent | cut -d'=' -f2)
  echo $SSMState
}

#Logic will go here, these are place holders for testing , RunningDistro is set

#Detects VM's Linux Distro & saves to $RunningDistro Variable
RunningDistro=$(detect_distro)

SSMStatus=$(get_ssmState)
TEST_ENDPT=$(test_endpoints)
if grep -q "failed" <<< "$TEST_ENDPT"; then
    echo -e "\n****Cannot resolve SSM endpoints, internet and/or DNS maynot be resolving**** \n"
    exit 1
else
    echo -e "\nRunning Remediation Script..."
    case $SSMStatus in 
    inactive )
      uninstall_ssm
      install_ssm
    ;;
    activating )
      uninstall_ssm
      install_ssm
    ;;
    active )
      uninstall_ssm
      install_ssm
    ;;
    "" )
      install_ssm
    ;;
    esac
fi