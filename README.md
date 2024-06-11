# Enterprise enabled infrastructure for Azure AI services
![Azure AI](./diagrams/ai_infrastructure.png)

Note to fix current issue in WebApp:
```bash
az webapp config set --startup-file "python3 -m gunicorn app:app" --name llmapp-rzca --resource-group rg-eai-llmapp
```

When demonstrating AML managed VNET nothing will happen until you create first compute instance. Go to AML portal a create one and demonstrate pending requests for Private Endpoint poping up in AML itself (control plane access), Key Vault and Storage.

# Enterprise AI infrastructure
Here are steps to showcase network performance and latencies.

```bash
export prefix="eai"

# Zone 1 to Zone 2, no network acceleration
az serial-console connect -n vm-na-z1-vm1 -g rg-$prefix-infra

# Zone 1 to Zone 2, with network acceleration
az serial-console connect -n vm-a-z1-vm1 -g rg-$prefix-infra

# Zone 1 to Zone 2, with network acceleration
az serial-console connect -n vm-a-z2-vm1 -g rg-$prefix-infra
az serial-console connect -n vm-a-z3-vm1 -g rg-$prefix-infra

```