import json
import logging

import boto3

from app.config import settings


logger = logging.getLogger(__name__)


def get_s3_client():

    return boto3.client(
        "s3",
        region_name=settings.AWS_REGION
    )


def get_config_from_s3():

    if not settings.S3_BUCKET:
        raise ValueError(
            "S3_BUCKET environment variable is not configured"
        )

    logger.info(
        "Retrieving configuration from S3"
    )

    s3 = get_s3_client()

    response = s3.get_object(
        Bucket=settings.S3_BUCKET,
        Key=settings.S3_CONFIG_KEY
    )

    content = response["Body"].read()

    return json.loads(
        content.decode("utf-8")
    )