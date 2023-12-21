import logging

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    logger = logging.getLogger()
    logger.info("In Hello World")
    return {"Hello": "World"}


def main() -> None:
    """Entrypoint for local development."""
    import logging
    import uvicorn

    logging.basicConfig(level=logging.DEBUG)
    uvicorn.run("app:app", host="127.0.0.1", port=8080)


if __name__ == "__main__":
    main()
