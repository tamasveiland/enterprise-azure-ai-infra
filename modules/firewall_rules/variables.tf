variable "firewall_policy_id" {
  type = string
  description = "ID of the firewall policy to associate with the firewall."
}

variable "openai_fqdn" {
  type = string
  description = "FQDN for the OpenAI service."
}

variable "llmapp_fqdn" {
  type = string
  description = "FQDN for the LLM app."
}

variable "llmapp_scm_fqdn" {
  type = string
  description = "FQDN for the LLM app SCM."
}

variable "dns_ip" {
  type        = string
  description = <<EOF
IP of the DNS server to be used for DNS resolution
EOF
}
