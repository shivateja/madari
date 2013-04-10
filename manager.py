#!/usr/bin/python

import os
import sys
from subprocess import call
from slot import slot
from dev import dev
import generator

try:
    from yaml import load
except:
    pyyaml_dir = os.getcwd()+"/PyYAML/"
    print "Yaml library not found. Trying to use library in %s" %pyyaml_dir
    if not sys.path.append(pyyaml_dir):
        print "Yaml library not found"
        print "Install it by running - 'python setup.py install' in %s" % pyyaml_dir
try:
    from crontab import CronTab
except:
    print "python-crontab library import failed. You will not be able to add job to crontab. Would you like to continue for generating scripts ? (y/n)"
    ans = str(raw_input())
    if ans == "y":
        pass
    else:
        print "Exiting.."
        sys.exit(1)

#
file_directory = "/etc/madari"
confFilePath = "config.yaml"
cronCommand = "bash %s/hourly.sh" %file_directory

# Self Explanatory
def die():
    sys.exit(1)
    

# Check if madari shell scripts directory exists. If not create the directory.
if not os.path.isdir(file_directory):
    if call(["sudo mkdir %s" %file_directory],shell=True):
        print "Could not create %s. Exiting"%file_directory
        die()

# Check if cron exists if not add one
def check_cron():                                                                #Writing job not working for unknown reason
    cron = CronTab(user="root")
    if cron.find_command(cronCommand):
        return
    else:
        print "add '0 * * * * bash /etc/madari/hourly.sh' to crontab for root"


def main():
    try:
        print "Reading %s" %(confFilePath)
        conf_file = open(confFilePath,"r")
    except:
        print "Could not open configuration file. Exiting..."
        die()
    try:
        print "Parsing configuration file."
        conf = load(conf_file)
    except:
        print "Error parsing the cofiguration file. Exiting..."
        die()
    devices = []
    for device,properties in conf.items():
        k = dev(device,properties)
        devices.append(k)
    if "stop" in sys.argv:
        for device in devices:
            call(["sudo tc qdisc del dev %s root"%device.name],shell=True)
        die()
    print "Generating shell scripts"
    generator.generate(devices,file_directory)
    print "Shell scripts successfully generated."
    print "Checking command exists in cron jobs"
    check_cron()
    for device in devices:
        print "Configuring %s" %device.name
        call(["sudo bash %s/%s.sh" %(file_directory,device.name)],shell=True)
        print
    print "Done ! Exiting."

if __name__=="__main__":
    main()
