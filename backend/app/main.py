import logging

from fastapi import FastAPI
from fastapi.responses import JSONResponse

from app.config import settings
from app.aws import get_config_from_s3


logging.basicConfig(
    level=settings.LOG_LEVEL,
    format=(
        "%(asctime)s "
        "%(levelname)s "
        "%(name)s "
        "%(message)s"
    )
)


logger = logging.getLogger(__name__)


app = FastAPI(
    title="Multi-Cloud Backend",
    version="1.0.0"
)


@app.get("/")
def root():

    return {
        "message": "Multi-Cloud Backend API"
    }


@app.get("/health")
def health():

    return {
        "status": "healthy"
    }


@app.get("/ready")
def ready():

    return {
        "status": "ready"
    }


@app.get("/api/info")
def info():

    logger.info(
        "Backend information requested"
    )

    return {
        "application": settings.APP_NAME,
        "environment": settings.APP_ENV,
        "cloud": "AWS",
        "platform": "EKS"
    }


@app.get("/api/config")
def config():

    try:

        config_data = get_config_from_s3()

        return {
            "source": "AWS S3",
            "data": config_data
        }

    except Exception as error:

        logger.error(
            "Failed to retrieve S3 configuration: %s",
            str(error)
        )

        return JSONResponse(
            status_code=500,
            content={
                "error": (
                    "Unable to retrieve "
                    "configuration"
                )
            }
        )