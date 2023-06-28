{pkgs, ... } :
with pkgs;
let
  tc-saluki-pkgs =  [
    lynis
    avahi-compat        #avahi compat library
    go                  #Go runtime
    hostapd             #host access point daemon
    iperf3              #network testing
    irqbalance          #irq balancer
    nats-server         #NATS server
    nettools            #network tools
    nssmdns             #name service switch and multicast dns
    openssl             #open ssl
    postgresql          #postgres
    sqlite              #sql lite
    patchelf            #elf patching tool
    #Wireless
    alfred              #Batman mesh alfred
    batctl              #Batman Mesh control
    iw                  #wireless
    wireless-regdb      #wireles regulatory database
    wpa_supplicant      #wpa supplicant
    #docker
    docker              #docker package
  ];
in
{
  environment.noXlibs = false;
  environment.systemPackages = tc-saluki-pkgs;
}