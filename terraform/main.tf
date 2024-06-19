terraform {
  required_providers {
    authentik = {
      source = "goauthentik/authentik"
      version = "2024.4.2"
    }
  }
}

provider "authentik" {
  url      = "http://127.0.0.1:9000"
  token    = "u1zXlztaYUygFeMSlMZaTZqxJgSqkWMF8oixDfFyfsQgJywuasSvDOJjpKyV"
  insecure = true
}

data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_scope_mapping" "jenkins" {
  managed_list = [
    "goauthentik.io/providers/oauth2/scope-email",
    "goauthentik.io/providers/oauth2/scope-openid",
    "goauthentik.io/providers/oauth2/scope-profile"
  ]
}

data "authentik_certificate_key_pair" "default" {
  name = "authentik Self-signed Certificate"
}

resource "authentik_provider_oauth2" "jenkins" {
  name               = "jenkins"
  client_id          = "jenkins"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  property_mappings  = data.authentik_scope_mapping.jenkins.ids
  signing_key        = data.authentik_certificate_key_pair.default.id
  redirect_uris      = [ "http://127.0.0.1:8080/securityRealm/finishLogin" ]
}

resource "authentik_application" "jenkins" {
  name              = "jenkins"
  slug              = "jenkins"
  protocol_provider = authentik_provider_oauth2.jenkins.id

}

resource "authentik_user" "saadali" {
  username = "saadali"
  name     = "saadali"
  password = "password"
}

resource "authentik_group" "group" {
  name         = "JenkinsAdmin"
  users        = [ authentik_user.saadali.id ]
}
