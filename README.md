<h1>Kawaii Shop</h1>
Kawaii shop is a mini REST API e-commerce project that made by Golang

<h2>Required</h2>
<ul>
    <li><a href="https://www.docker.com/">Docker</a></li>
    <li><a href="https://www.postman.com/">Postman</a></li>
    <li><a href="https://code.visualstudio.com/">IDE (Vscode)</a></li>
    <li><a href="https://cloud.google.com/sdk/docs/install">GCP CLI</a></li>
</ul>

<h2>Database Schema</h2>

<img alt="schema" src="./screenshots/schema0.0.3.png"/>

<h2>Start PostgreSQLon Docker 🐋</h2>

```bash
docker run --name kawaii_db_test -e POSTGRES_USER=kawaii -e POSTGRES_PASSWORD=123456 -p 4444:5432 -d postgres:alpine
```

<h2>Execute a container and CREATE a new database</h2>

```bash
docker exec -it kawaii_db_test bash
psql -U kawaii
CREATE DATABASE kawaii_db_test;
\l
```

<h2>Migrate command</h2>

```bash
# Migrate up
migrate -database 'postgres://kawaii:123456@0.0.0.0:4444/kawaii_db_test?sslmode=disable' -source file://D:/path-to-migrate -verbose up

# Migrate down
migrate -database 'postgres://kawaii:123456@0.0.0.0:4444/kawaii_db_test?sslmode=disable' -source file://D:/path-to-migrate -verbose down
```

<h2>Build and Push to GCP</h2>

```bash
# Build
docker build -t asia.gcr.io/prject-id/container-bucket .

# Push
docker push asia.gcr.io/prject-id/container-bucket

# If push doesn't work, run this command below and then push again
gcloud auth configure-docker
```

<h2>.env Exmaple</h2>

```bash
APP_HOST=
APP_PORT=
APP_NAME=
APP_VERSION=
APP_BODY_LIMIT=
APP_READ_TIMEOUT=
APP_WRTIE_TIMEOUT=
APP_API_KEY=
APP_ADMIN_KEY=
APP_FILE_LIMIT=
APP_GCP_BUCKET=

JWT_SECRET_KEY=
JWT_ACCESS_EXPIRES=
JWT_REFRESH_EXPIRES=

DB_HOST=
DB_PORT=
DB_PROTOCOL=
DB_USERNAME=
DB_PASSWORD=
DB_DATABASE=
DB_SSL_MODE=
DB_MAX_CONNECTIONS=

FILE_LOG_PATH=
```

<h2>Postman</h2>
<ul>
    <li><a href="./kawaii-shop-tutorial.postman_collection.json">Collection</a></li>
    <li><a href="./kawaii-shop-tutorial.postman_environment.json">Environment</a></li>
</ul>