resource "aws_cognito_user_pool" "this" {
    auto_verified_attributes  = []
    mfa_configuration         = "OFF"
    name                      = "main_user_pool"
    tags                      = {}
    tags_all                  = {
        "Environment" = "Development"
        "Owner"       = "Grupo 4"
        "Project"     = "Serverles cv builder"
    }

    account_recovery_setting {
        recovery_mechanism {
            name     = "admin_only"
            priority = 1
        }
    }

    admin_create_user_config {
        allow_admin_create_user_only = false
    }

    email_configuration {
        email_sending_account = "COGNITO_DEFAULT"
    }

    password_policy {
        minimum_length                   = 8
        require_lowercase                = false
        require_numbers                  = false
        require_symbols                  = false
        require_uppercase                = false
        temporary_password_validity_days = 7
    }

    verification_message_template {
        default_email_option = "CONFIRM_WITH_CODE"
    }
}