job "example-multiport" {
  datacenters = ${datacenters}
  type        = "service"

  group "app" {
    count = 1

    network {
      # Define multiple ports for the service
      port "api" {
        to = 8080
      }
      port "metrics" {
        to = 9090
      }
      port "admin" {
        to = 8081
      }
    }

    # With Consul v2 APIs, we can register multiple services for different ports
    # This enables better service mesh capabilities
    
    # Main API service
    service {
      provider = "consul"
      name     = "example-api"
      port     = "api"
      
      tags = [
        "api",
        "v2",
        "traefik.enable=true",
        "traefik.http.routers.example-api.entrypoints=https",
        "traefik.http.routers.example-api.rule=Host(`api.${domain}`)",
        "traefik.http.routers.example-api.tls=true"
      ]

      check {
        type     = "http"
        path     = "/health"
        port     = "api"
        interval = "10s"
        timeout  = "2s"
      }
      
      # Enable Consul Connect for service mesh
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "postgres"
              local_bind_port  = 5432
            }
          }
        }
      }
    }

    # Metrics service on a different port
    service {
      provider = "consul"
      name     = "example-metrics"
      port     = "metrics"
      
      tags = [
        "metrics",
        "prometheus"
      ]

      check {
        type     = "http"
        path     = "/metrics"
        port     = "metrics"
        interval = "30s"
        timeout  = "5s"
      }
    }

    # Admin service on yet another port
    service {
      provider = "consul"
      name     = "example-admin"
      port     = "admin"
      
      tags = [
        "admin",
        "internal"
      ]

      check {
        type     = "tcp"
        port     = "admin"
        interval = "30s"
        timeout  = "5s"
      }
    }

    task "app" {
      driver = "docker"

      config {
        image = "example/multiport-app:latest"
        ports = ["api", "metrics", "admin"]
      }

      resources {
        cpu    = 256
        memory = 512
      }
    }
  }
}