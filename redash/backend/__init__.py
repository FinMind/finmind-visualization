from redash.backend import clients, finmind, router, application
from redash.backend.database import DB
from redash.backend.finmind import FinMindApi
from redash.backend.router import Router

finmind_api = FinMindApi()
db = DB()
router = Router()
