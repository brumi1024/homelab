# Test configuration for the Nomad jobs module
# This test validates Nomad job deployments

variables {
  nomad_address = "https://test-nomad.local:4646"
  datacenters   = ["dc1"]
  domain        = "test.local"
  
  # Traefik configuration
  traefik_image_version           = "3.0"
  traefik_volumes_acme            = "/opt/traefik/acme"
  traefik_volumes_logs            = "/opt/traefik/logs"
  traefik_consul_provider_address = "localhost:8500"
  traefik_acme_ca_server          = "https://acme-staging-v02.api.letsencrypt.org/directory"
  proxmox_address                 = "https://proxmox.test.local:8006"
  
  # Other service versions
  whoami_image_version            = "latest"
  yarr_image_version              = "latest"
  yarr_volumes_data               = "/opt/yarr/data"
  minio_image_version             = "latest"
  minio_volumes_data              = "/opt/minio/data"
  actual_image_version            = "latest"
  actual_volumes_server           = "/opt/actual/server"
  actual_volumes_user             = "/opt/actual/user"
  linkding_image_version          = "latest"
  linkding_volumes_data           = "/opt/linkding/data"
  openbooks_image_version         = "latest"
  openbooks_volumes_books         = "/opt/openbooks/books"
  calibre_web_image_version       = "latest"
  calibre_web_volumes_config      = "/opt/calibre-web/config"
  calibre_web_volumes_books       = "/opt/calibre-web/books"
  postgres_image_version          = "15"
  postgres_volumes_data           = "/opt/postgres/data"
  registry_image_version          = "2"
  registry_volumes_data           = "/opt/registry/data"
  pigallery2_image_version        = "latest"
  pigallery2_volumes_config       = "/opt/pigallery2/config"
  pigallery2_volumes_data         = "/opt/pigallery2/data"
  pigallery2_volumes_images       = "/opt/pigallery2/images"
  pigallery2_volumes_tmp          = "/opt/pigallery2/tmp"
}

# Test core infrastructure jobs
run "core_jobs" {
  command = plan

  assert {
    condition     = nomad_job.traefik.jobspec != null
    error_message = "Traefik job should be defined"
  }

  assert {
    condition     = nomad_job.whoami.jobspec != null
    error_message = "Whoami job should be defined"
  }

  assert {
    condition     = nomad_job.postgres.jobspec != null
    error_message = "Postgres job should be defined"
  }

  assert {
    condition     = nomad_job.registry.jobspec != null
    error_message = "Registry job should be defined"
  }
}

# Test application jobs
run "application_jobs" {
  command = plan

  assert {
    condition     = nomad_job.yarr.jobspec != null
    error_message = "Yarr job should be defined"
  }

  assert {
    condition     = nomad_job.minio.jobspec != null
    error_message = "MinIO job should be defined"
  }

  assert {
    condition     = nomad_job.actual.jobspec != null
    error_message = "Actual job should be defined"
  }

  assert {
    condition     = nomad_job.linkding.jobspec != null
    error_message = "Linkding job should be defined"
  }

  assert {
    condition     = nomad_job.openbooks.jobspec != null
    error_message = "Openbooks job should be defined"
  }

  assert {
    condition     = nomad_job.calibre_web.jobspec != null
    error_message = "Calibre Web job should be defined"
  }

  assert {
    condition     = nomad_job.pigallery2.jobspec != null
    error_message = "PiGallery2 job should be defined"
  }
}

# Test job template rendering
run "template_rendering" {
  command = plan

  assert {
    condition     = can(regex("datacenters\\s*=\\s*\\[\"dc1\"\\]", nomad_job.whoami.jobspec))
    error_message = "Whoami job should be configured for dc1 datacenter"
  }

  assert {
    condition     = can(regex("whoami\\.test\\.local", nomad_job.whoami.jobspec))
    error_message = "Whoami job should use the correct domain"
  }
}