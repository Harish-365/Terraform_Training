##- The template (template_file) is like a blueprint.

##- Purpose: This loads init.cfg as a template for cloud-init.
##- How It Works: Terraform reads the file init.cfg and stores its contents.
##- Use Case: Allows Terraform to reuse and dynamically modify this file


data "template_file" "install-apache" {   
    template = file("init.cfg")
}

## Cloud-init (template_cloud_config) then processes and applies that blueprint during instance startup.

##- Purpose: Sets up cloud-init formatting for instance configuration.
##- gzip = false → Disables compression for easy readability.
##- base64_encode = false → Stores the config as plain text instead of encoding it


data "template_cloudinit_config" "install-apache-config" { 
    gzip = false
    base64_encode = false

##- Purpose: This section attaches the cloud-init file (init.cfg) to the VM setup.
##- filename = "init.cfg" → Specifies the name of the config file.
##- content_type = "text/cloud-config" → Ensures it follows cloud-init formatting.
##- content = data.template_file.install-apache.rendered → Uses the processed file content from Step 1.

    part {
        filename = "init.cfg"
        content_type = "text/cloud-config"
        content = data.template_file.install-apache.rendered
    }

}