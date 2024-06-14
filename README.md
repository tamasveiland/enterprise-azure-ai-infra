# Enterprise enabled infrastructure for Azure AI services
![Azure AI](./diagrams/ai_infrastructure.png)

Note to fix current issue in WebApp:
```bash
az webapp config set --startup-file "python3 -m gunicorn app:app" --name llmapp-wnsp --resource-group rg-cetc-llmapp
```

When demonstrating AML managed VNET nothing will happen until you create first compute instance. Go to AML portal a create one and demonstrate pending requests for Private Endpoint poping up in AML itself (control plane access), Key Vault and Storage.

# Enterprise AI infrastructure
## Network latencies
Use serial console to test throughput via ```iperf3 -c vm-a-z2-vm1``` or latency via ```qperf vm-a-z2-vm1 tcp_lat```. Server-side is preinstalled and running on each machine. Machines are with network acceleration enabled or disabled, in various zones or in proximity placement groups.

## GPU example
Terraform deploy GPU VM and uses cloud-init script to install NVIDIA CUDA drivers, install ollama a pre-download Phi3 model (14B version in 6-bit quantization so it fits 16GB of GPU RAM of T4 machine). Then use ```run.sh``` in home folder to start chat with local LLM.