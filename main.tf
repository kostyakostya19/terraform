terraform {
  required_providers {
    google = {
      source   = "hashicorp/google"
//      version = "~> 3.5"
    }
    local = {
      source  = "hashicorp/local"
//      version = "~> 2.1"
    }
  }
}

provider "google" {
  project     = var.project
  region      = var.region
  credentials = var.credentials_file_path
}

resource "google_compute_instance" "default" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      size  = 20
      type  = "pd-standard"
      image = var.image
    }
  }

  attached_disk {
    source = google_compute_disk.database_disk.id
  }

  network_interface {
    network = "default"
    access_config {
      // External IP assigned
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_key_path)}"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  tags = ["system"]

//  provisioner "remote-exec" {
//    connection {
//      type        = "ssh"
//      user        = var.ssh_user
//      private_key = file(var.ssh_private_key_path)
//      host        = self.network_interface[0].access_config[0].nat_ip
//    }
//  
//    inline = [
//      "sudo mkfs.ext4 /dev/sdb",
//      "sudo mkdir -p /mnt/database_disk",
//      "echo '/dev/sdb /mnt/database_disk ext4 defaults 0 2' | sudo tee -a /etc/fstab",
//      "sudo mount -a"
//    ]
//  }

}

resource "google_compute_disk" "database_disk" {
  name   = "database-disk"
  type   = "pd-standard"
  zone   = var.zone
  size   = 4
  labels = {
    type ="database"
  }
}

output "instance_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}

output "ssh_user" {
  value = var.ssh_user
}

output "ssh_command" {
  value = "ssh ${var.ssh_user}@${google_compute_instance.default.network_interface[0].access_config[0].nat_ip}"
  description = "SSH command to connect to the instance"
}


resource "local_file" "instance_ip_file" {
  content  = "IP Address: ${google_compute_instance.default.network_interface[0].access_config[0].nat_ip}\nSSH User: user\nSSH Command: ssh ${var.ssh_user}@${google_compute_instance.default.network_interface[0].access_config[0].nat_ip}"
  filename = "${path.module}/instance_info.txt"
}