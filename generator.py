"""
Library for generating shell script.
"""
import sys
from dev import dev
from slot import slot
def generate(devices,file_directory):
    try:
        main_script = open(file_directory+"/hourly.sh","w")
    except:
        print "Could not create shell script in given directory. Requires root access"
        sys.exit(1)
    for device in devices:
        interface = device.name
        device.slots.sort(key = lambda x : x.startTime)
        for i in xrange(len(device.slots) - 1):
            if device.slots[i].endTime > device.slots[i+1].startTime:
                print "Error parsing slots in interface %s" %device.name
                sys.exit(1)
        try:
            script = open(file_directory + "/" + device.name + ".sh","w")
        except IOError:
            print "Could not create shell script in given directory. Requires root access"
            sys.exit(1)
        script.write("#!/bin/bash\ndate=$(date +%T)\nIFS=:\nary=($date)\nhour=${ary[0]}\ncase \"$hour\" in\n")
        for slot in device.slots:
            for time in xrange(slot.startTime,slot.endTime):
                script.write("%s) " %time)
                script.write("tc qdisc del dev %s root\n" %interface)
                script.write("tc qdisc add dev %s root handle 1:0 htb default 2\n" %interface)
                script.write("tc class add dev %s parent 1:0 classid 1:1 htb rate %s\n" %(interface,device.bandwidth))
                script.write("tc class add dev %s parent 1:1 classid 1:2 htb rate %s\n"%(interface,device.bandwidth))
                for i in xrange(3,3+len(slot.aclIPs)):
                    ip = slot.aclIPs.keys()[i-3]
                    if slot.aclIPs[ip]["download-limit"]:
                        limit = slot.aclIPs[ip]["download-limit"]
                    else:
                        limit = slot.aclIPs[ip]["upload-limit"]
                    if slot.aclIPs[ip]["strict"]:
                        ceil = limit
                    else:
                        ceil = device.bandwidth
                    script.write("tc class add dev %s parent 1:1 classid 1:%i htb rate %s ceil %s\n"%(interface,i,limit,ceil))
                for i in xrange(2,i+1):
                    script.write("tc qdisc add dev %s parent 1:%i handle %i: sfq perturb 10\n" %(interface,i,i*10))
                for i,ip in enumerate(slot.aclIPs,start=3):
                    script.write("tc filter add dev %s parent 1:0 protocol ip prio 1 u32 match ip %s %s flowid 1:%i\n"%(interface,"src" if slot.aclIPs[ip]["download-limit"] else "dst",ip,i))
                for ip in slot.blockIPs:
                    script.write("iptables -I INPUT -i %s -s %s -j DROP\n" %(interface,ip))
                script.write(";;\n")
        script.write("*) tc qdisc del dev %s root\n" %interface)
        script.write(";;\n")
        script.write("esac\n")
        script.close
        main_script.write("bash %s.sh\n"%interface)
