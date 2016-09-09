mdaq_dsp_start("udp_send_demo_scig\udp_send_demo.out", 0.001);

data = [];
udp_open(mdaq_get_ip(), 9090)
for i=1:10
    data = [data; udp_recv(3,2000)];

end
plot(data)
mdaq_dsp_stop()
udp_close()
