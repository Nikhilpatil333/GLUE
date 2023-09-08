variable "bucket1" {
    type = string
    default = "gluejob-script-group2-08-09-2023"
}

variable "bucket2" {
    type = string
    default = "Raw-datazone-group2-08-09-2023"
}

variable "bucket_name" {
    type = string
    default = "My Bucket" 
}

variable "glue_name_1" {
    type = string
    default = "Data-Merging"
}

variable "arn" {
    type = string
    default = "arn:aws:iam::300758866129:role/LabRole"
}

variable "glue_retries" {
    type = string
    default = "0"
}

variable "glue_timeout" {
    type = number
    default = 60
}

variable "number_of_workers" {
    type = number
    default = 3
}

variable "glue_standard" {
    type = string
    default = "Standard"
}