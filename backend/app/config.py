import os


class Settings:

    APP_NAME = os.getenv(
        "APP_NAME",
        "Multi-Cloud Backend"
    )

    APP_ENV = os.getenv(
        "APP_ENV",
        "development"
    )

    LOG_LEVEL = os.getenv(
        "LOG_LEVEL",
        "INFO"
    )

    AWS_REGION = os.getenv(
        "AWS_REGION",
        "eu-central-1"
    )

    S3_BUCKET = os.getenv(
        "S3_BUCKET",
        ""
    )

    S3_CONFIG_KEY = os.getenv(
        "S3_CONFIG_KEY",
        "config.json"
    )


settings = Settings()