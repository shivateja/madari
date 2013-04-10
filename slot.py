import sys
class slot:
    def __init__(self,time,configs):
        try:
            self.startTime = int(time[:time.find(":")])
            self.endTime = int(time[time.find("-")+1 :time.find(":",3)])
            if(self.startTime >= self.endTime):
                print "Error while parsing slots. Exiting..."
                sys.exit(1)
        except:
            print "Error while parsing slots. Exiting..."
            sys.exit(1)
        try:
            self.blockIPs = configs["block"]["ip-addresses"]
        except:
            self.blockIPs = None
        self.aclIPs = {}
        try:
            self.defaultDownloadLimit = configs["default-download-limit"]
            self.defaultUploadLimit = configs["default-upload-limit"]
        except:
            print "Default download limits required in slot %s" %time
        for ip in configs["acl"].keys():
            try:
                if configs["acl"][ip]:
                    rules = configs["acl"][ip].keys()
                else:
                    rules = []
                if "strict" in rules:
                    if configs["acl"][ip]["strict"]:
                        self.aclIPs[ip] = {"strict" : True}
                    else:
                        self.aclIPs[ip] = {"strict" : False}
                else:
                    self.aclIPs[ip] = { "strict" : False}
                if "download-limit" in rules:
                    if configs["acl"][ip]["download-limit"]:
                        self.aclIPs[ip]["download-limit"] = configs["acl"][ip]["download-limit"]
                    else:
                        self.aclIPs[ip]["download-limit"] = False
                else:
                    self.aclIPs[ip]["download-limit"] = self.defaultDownloadLimit
                if "upload-limit" in rules:
                    if configs["acl"][ip]["upload-limit"] != "None":
                        self.aclIPs[ip]["upload-limit"] = configs["acl"][ip]["upload-limit"]
                    else:
                        self.aclIPs[ip]["upload-limit"] = False
                else:
                    self.aclIPs[ip]["upload-limit"] = self.defaultUploadLimit
            except:
                print "Error parsing slot %s" %time
        #print self.aclIPs    
