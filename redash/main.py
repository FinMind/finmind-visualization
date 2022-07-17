from redash.api import v1
from redash.backend.application import FastAPI

app = FastAPI()
app.include_router(v1.api_router)
