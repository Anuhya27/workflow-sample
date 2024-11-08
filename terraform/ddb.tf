# main.tf
resource "aws_dynamodb_table" "file_processing_table" {
  name           = "test"
  billing_mode   = "PAY_PER_REQUEST"  
  hash_key       = "BucketAndPath"
  range_key      = "CreatedTimeStamp"

  # Primary key attributes
  attribute {
    name = "BucketAndPath"
    type = "S"  # String type
  }

  attribute {
    name = "CreatedTimeStamp"
    type = "S"  # String type for ISO timestamp
  }

  # GSI attributes
  attribute {
    name = "jobRunId"
    type = "S"  
  }

  # Global Secondary Index
  global_secondary_index {
    name               = "jobRunId-CreatedTimeStamp-index"
    hash_key          = "jobRunId"
    range_key         = "CreatedTimeStamp"
    projection_type   = "ALL"  # Projecting all attributes
  }

  # Point in time recovery
  point_in_time_recovery {
    enabled = true
  }

  # Server-side encryption
  server_side_encryption {
    enabled = true
  }

  # Tags
  tags = {
    "Name"               = var.Name
    "Cost_Center_Name"   = var.Cost_Center_Name
    "Department"         = var.Department
    "epi:team"           = var.Team
    "epi:supported-by"   = var.SupportedBy
    "epi:owner"          = var.Owner
    "epi:environment"    = var.Environment
    "epi:product-stream" = var.ProductStream
  }
}

# TTL Attribute (if needed)
# Uncomment and modify if you need TTL functionality
# ttl {
#   enabled        = true
#   attribute_name = "TTL"
# }