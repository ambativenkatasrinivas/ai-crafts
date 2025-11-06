from sqlmodel import SQLModel, create_engine, Session

# PostgreSQL connection URL format:
# postgresql+psycopg2://<username>:<password>@<host>:<port>/<database_name>

DATABASE_URL = "postgresql+psycopg2://postgres:password@localhost:5432/ai-crafts"

engine = create_engine(DATABASE_URL, echo=True)

def init_db():
    SQLModel.metadata.create_all(engine)

def get_session():
    with Session(engine) as session:
        yield session
