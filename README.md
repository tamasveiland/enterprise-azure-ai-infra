# enterprise-azure-ai-infra

Note to fix current issue in WebApp:
```bash
az webapp config set --startup-file "python3 -m gunicorn app:app" --name llmapp-rzca --resource-group rg-eai-llmapp
```