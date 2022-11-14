terraform {
  cloud {
    organization = "mythal"

    workspaces {
      name = "roze"
    }
  }
}

terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = ">= 1.29.4"
    }
  }
}

provider "linode" {
  token = var.linode_token
}


resource "linode_image" "roze" {
  label  = "Roze"
  region = var.region

  file_path = var.image_path
  file_hash = filemd5(var.image_path)
}


resource "linode_instance_disk" "nixos" {
  label     = "nixos"
  linode_id = linode_instance.roze.id
  size      = var.nixos_size

  image = linode_image.roze.id
}

resource "linode_instance_disk" "state" {
  label      = "state"
  linode_id  = linode_instance.roze.id
  filesystem = "ext4"
  size       = linode_instance.roze.specs.0.disk - var.swap_size - var.nixos_size
  lifecycle {
    prevent_destroy = true
  }
}

resource "linode_instance_disk" "swap" {
  label      = "swap"
  linode_id  = linode_instance.roze.id
  size       = 512
  filesystem = "swap"
}

resource "linode_instance_config" "roze" {
  label     = "Roze"
  linode_id = linode_instance.roze.id
  kernel    = "linode/grub2"
  booted    = true
  devices {
    sda {
      disk_id = linode_instance_disk.nixos.id
    }
    sdb {
      disk_id = linode_instance_disk.swap.id
    }
    sdc {
      disk_id = linode_instance_disk.state.id
    }
  }
  helpers {
    updatedb_disabled  = false
    devtmpfs_automount = false
    distro             = false
    modules_dep        = false
    network            = false
  }
}

resource "linode_volume" "roze-state" {
  label = "roze-state"
  region = linode_instance.roze.region
  size = 10
  linode_id = linode_instance.roze.id
  lifecycle {
    prevent_destroy = true
  }
}

resource "linode_instance" "roze" {
  label  = "roze"
  region = var.region
  type   = var.instance_type
  lifecycle {
    # create_before_destroy = true
    # replace_triggered_by = [
    #   linode_image.roze
    # ]
  }
}
