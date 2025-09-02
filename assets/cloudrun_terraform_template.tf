# cloud run
module "cloud_cloudrun" {
  source = "<<repository URL for internal Cloud Run module>>"
  version = "<<version no. for consistency>>"
  project = <<GCP project ID>>
  # Cloud Run Config
  service_name = <<References for the Cloud Run service name>>
  service_account_name = <<Uses for the associated service account>>
  # Regional Deployment  
  regional_configs = [

    { region = "us-central1"},
    { region = "us-east4" }
  ]
  # Resource Allocation CPU & Memory Limits
  resources = {
    limits = {
      cpu    = "2000m"
      memory = "1024Mi"
    }
    requests = {
      cpu    = "1000m"
      memory = "512Mi" 
    }
  }
  # Security Configuration
  wif_sa = local.wif_sa # 
  allow_unauthenticated = false # 

}

# cloud spanner
module "cloud_spannery" {
  source = "<<repository URL for internal Cloud Run module>>"
  version = "<<version no. for consistency>>"
  project = <<GCP project ID>>
  instance_name       = <<spanner instance name>>
  spanner_db_name     = <<spanner db anme>>
  database_dialect    = "GOOGLE_STANDARD_SQL"
  deletion_protection = true
  database_iam        = local.spanner_roles

  depends_on          = [
    module.cloud_spanner_instance
  ]
  ddl_input = split("\n", chomp(file("<<file.sql>>")))
}

# Service account
module "cloud-sa" {
  source = "<<repository URL for internal Cloud Run module>>"
  version = "<<version no. for consistency>>"
  project = <<GCP project ID>>
  names         = ["<<gcp project name>>"]
  display_name  = "Service account for <<some jobs>>"
  generate_keys = true
  description   = "Service account for <<some jobs>> (temporary)"
}

# pub/sub
module "feed_pubsub_topic" {
  source = "<<repository URL for internal Cloud Run module>>"
  version = "<<version no. for consistency>>"
  project = <<GCP project ID>>
  pubsub_topics = [
    "${<<feed topic>>}"
  ]
  bindings = {
    "roles/pubsub.publisher" = [
        "serviceAccount:${<<temp service account>>}",
    ],
    "roles/pubsub.viewer" = [
    ]
    "roles/pubsub.subscriber" = [
    ]
  }
}
