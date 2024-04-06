variable "project" {
  description = "The GCP project ID."
}

variable "region" {
  description = "The GCP region."
  default     = "europe-central2"
}

variable "ssh_key_path" {
  description = "Path to the public SSH key."
}

variable "name" {
  description = "Name of VM."
  default     = "vm"
}

variable "machine_type" {
  description = "The type of GCE machine."
  default     = "e2-medium"
}

variable "zone" {
  description = "The GCP zone."
  default     = "europe-central2-a"
}

variable "image" {
  description = "Image to setup."
  default     = "debian-cloud/debian-9"
}

variable "credentials_file_path" {
  description = "The path to the JSON file that contains your GCP credentials"
}

variable "ssh_user" {
  description = "SSH user."
}

variable "ssh_private_key_path" {
  description = "Private key"
}