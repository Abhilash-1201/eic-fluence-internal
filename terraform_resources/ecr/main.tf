#################ECR REPOS ####################################
resource "aws_ecr_repository" "fluence-devops" {
    count                       =  length(var.image_names)
    name                        =  var.image_names[count.index]
    image_tag_mutability        =  var.image_tag_mutability
    force_delete                =  var.force_delete
    image_scanning_configuration {
        scan_on_push            =  var.scan_images_on_push
    } 
    encryption_configuration     {
        encryption_type         = var.encryption_type
        #kms_key                = encryption_configuration.value.kms_key
    }
    tags                        = var.tags
}