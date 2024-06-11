resource "azurerm_firewall_policy_rule_collection_group" "openai" {
  name               = "ai-group"
  firewall_policy_id = var.firewall_policy_id
  priority           = 100

  application_rule_collection {
    name     = "openai"
    priority = 100
    action   = "Allow"

    rule {
      name              = "openai"
      description       = "Allow access to OpenAI service"
      source_addresses  = ["*"]
      destination_fqdns = [var.openai_fqdn]

      protocols {
        port = 443
        type = "Https"
      }
    }
  }

  application_rule_collection {
    name     = "github"
    priority = 110
    action   = "Allow"

    rule {
      name              = "github"
      description       = "Allow access to GitHub"
      source_addresses  = ["*"]
      destination_fqdns = ["github.com", "api.github.com", "*.githubusercontent.com"]

      protocols {
        port = 443
        type = "Https"
      }
    }
  }

  application_rule_collection {
    name     = "azure"
    priority = 120
    action   = "Allow"

    rule {
      name             = "azure-sites"
      description      = "Allow access to Azure portals"
      source_addresses = ["*"]
      destination_fqdns = [
        "portal.azure.com",
        "management.azure.com",
        "functions.azure.com",
        "login.microsoftonline.com",
        "graph.windows.net",
        "oai.azure.com",
        "emails-stable.azure.net",
        "*.portal.azure.net",
        "service.bmx.azure.com",
      ]

      protocols {
        port = 443
        type = "Https"
      }
    }

    rule {
      name             = "appservice-build"
      description      = "Allow access to App Service build dependencies"
      source_addresses = ["*"]
      destination_fqdns = [
        "oryx-cdn.microsoft.io",
        "pypi.org",
        "files.pythonhosted.org",
        "npmjs.com",
        "registry.npmjs.org",
        "nuget.org",
        "api.nuget.org",
        "dotnet.microsoft.com",
      ]

      protocols {
        port = 443
        type = "Https"
      }
    }
  }

  application_rule_collection {
    name     = "internal-apps"
    priority = 130
    action   = "Allow"

    rule {
      name             = "llmapps"
      description      = "Allow access to LLM apps"
      source_addresses = ["*"]
      destination_fqdns = [
        var.llmapp_fqdn,
        var.llmapp_scm_fqdn,
        "spoppe-b.azureedge.net",
      ]

      protocols {
        port = 443
        type = "Https"
      }
    }
  }

  network_rule_collection {
    name     = "dns"
    priority = 200
    action   = "Allow"

    rule {
      name                  = "dns"
      description           = "dns"
      source_addresses      = ["*"]
      destination_addresses = [var.dns_ip]
      destination_ports     = ["53"]
      protocols             = ["UDP", "TCP"]
    }
  }
}
