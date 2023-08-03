resource "shoreline_notebook" "mysql_slow_queries_incident" {
  name       = "mysql_slow_queries_incident"
  data       = file("${path.module}/data/mysql_slow_queries_incident.json")
  depends_on = [shoreline_action.invoke_db_explain_indexes,shoreline_action.invoke_db_credentials,shoreline_action.invoke_increase_max_connections]
}

resource "shoreline_file" "db_explain_indexes" {
  name             = "db_explain_indexes"
  input_file       = "${path.module}/data/db_explain_indexes.sh"
  md5              = filemd5("${path.module}/data/db_explain_indexes.sh")
  description      = "Lack of appropriate indexes on database tables causing slow query performance."
  destination_path = "/agent/scripts/db_explain_indexes.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "db_credentials" {
  name             = "db_credentials"
  input_file       = "${path.module}/data/db_credentials.sh"
  md5              = filemd5("${path.module}/data/db_credentials.sh")
  description      = "Set MySQL credentials"
  destination_path = "/agent/scripts/db_credentials.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "increase_max_connections" {
  name             = "increase_max_connections"
  input_file       = "${path.module}/data/increase_max_connections.sh"
  md5              = filemd5("${path.module}/data/increase_max_connections.sh")
  description      = "Increase the number of database connections to handle more traffic and reduce the likelihood of slow queries."
  destination_path = "/agent/scripts/increase_max_connections.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_db_explain_indexes" {
  name        = "invoke_db_explain_indexes"
  description = "Lack of appropriate indexes on database tables causing slow query performance."
  command     = "`chmod +x /agent/scripts/db_explain_indexes.sh && /agent/scripts/db_explain_indexes.sh`"
  params      = ["DATABASE_NAME","USERNAME","PASSWORD"]
  file_deps   = ["db_explain_indexes"]
  enabled     = true
  depends_on  = [shoreline_file.db_explain_indexes]
}

resource "shoreline_action" "invoke_db_credentials" {
  name        = "invoke_db_credentials"
  description = "Set MySQL credentials"
  command     = "`chmod +x /agent/scripts/db_credentials.sh && /agent/scripts/db_credentials.sh`"
  params      = ["USERNAME","PASSWORD"]
  file_deps   = ["db_credentials"]
  enabled     = true
  depends_on  = [shoreline_file.db_credentials]
}

resource "shoreline_action" "invoke_increase_max_connections" {
  name        = "invoke_increase_max_connections"
  description = "Increase the number of database connections to handle more traffic and reduce the likelihood of slow queries."
  command     = "`chmod +x /agent/scripts/increase_max_connections.sh && /agent/scripts/increase_max_connections.sh`"
  params      = []
  file_deps   = ["increase_max_connections"]
  enabled     = true
  depends_on  = [shoreline_file.increase_max_connections]
}

