#!/bin/bash
apt update
DEBIAN_FRONTEND=noninteractive apt install -y iperf3 qperf

# Enable iperf server
cat <<EOF >/etc/systemd/system/iperf3.service
[Unit]
Description=iperf3 server
After=syslog.target network.target auditd.service
[Service]
ExecStart=/usr/bin/iperf3 -s
[Install]
WantedBy=multi-user.target
EOF

systemctl enable iperf3
systemctl start iperf3

# Enable qperf server
cat <<EOF >/etc/systemd/system/qperf.service
[Unit]
Description=qperf server
After=syslog.target network.target auditd.service
[Service]
ExecStart=/usr/bin/qperf
[Install]
WantedBy=multi-user.target
EOF

systemctl enable qperf
systemctl start qperf

