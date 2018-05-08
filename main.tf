terraform {
  backend "gcs" {
    bucket = "mako-tfstate"
    prefix = "terraform/state"
  }

  required_version = ">= 0.11.7"
}

provider "heroku" {
  api_key = "${var.api_key}"
  email   = "${var.email}"
}

locals {
  stages = [
    "review",
    "staging",
    "production",
  ]
}

resource "random_pet" "application" {
  lifecycle {
    create_before_destroy = true
  }
}

resource "heroku_app" "application" {
  buildpacks = [
    "heroku/nodejs",
  ]

  config_vars = "${var.config_vars}"

  name   = "${random_pet.application.id}-${element(local.stages, count.index)}"
  region = "${var.region}"
  stack  = "container"

  count = "${length(local.stages)}"
}

resource "heroku_pipeline" "application" {
  name = "pipeline"
}

resource "heroku_addon" "hostedgraphite" {
  app  = "${element(heroku_app.application.*.name, count.index)}"
  plan = "hostedgraphite:free"

  count = "${length(local.stages)}"
}

resource "heroku_pipeline_coupling" "application" {
  app      = "${element(heroku_app.application.*.name, count.index)}"
  pipeline = "${heroku_pipeline.application.id}"
  stage    = "${element(local.stages, count.index)}"

  count = "${length(local.stages)}"
}
