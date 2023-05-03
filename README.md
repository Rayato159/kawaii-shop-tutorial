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

<h2>In case you don't want to use Google Cloud storage, Please follow this step</h2>
<p><strong>***Don't forget to change a function that related along with files module in products and orders module</strong></p>

<ol>
<li>

<p>Add this to your config for IAppConfig in config.go</p>

```go
type IAppConfig interface {
	Host() string
	Port() int
    ...
}

...
func (a *app) Host() string                { return a.host }
func (a *app) Port() int                   { return a.port }
```
</li>
<li>

<p>Add this middleware handler in your middleware module in middlewaresHandler.go</p>

```go
type IMiddlewaresHandler interface {
	StreamingFile() fiber.Handler
    ...
}

...
func (h *middlewaresHandler) StreamingFile() fiber.Handler {
	return filesystem.New(filesystem.Config{
		Root: http.Dir("./assets/images"),
	})
}
```
</li>
<li>

<p>Declare a StrammingFile() in func (s *server) Start() {} in server.go</p>

```go
func (s *server) Start() {
    ...
	s.app.Use(middlewares.StreamingFile())
}
```
</li>
<li>

<p>Add this usecase in your files module in filesUsecase.go</p>

```go
func (u *filesUsecase) uploadToStorageWorker(ctx context.Context, jobs <-chan *files.FileReq, results chan<- *files.FileRes, errs chan<- error) {
	for job := range jobs {
		cotainer, err := job.File.Open()
		if err != nil {
			errs <- err
			return
		}
		b, err := ioutil.ReadAll(cotainer)
		if err != nil {
			errs <- err
			return
		}

		// Upload an object to storage
		dest := fmt.Sprintf("./assets/images/%s", job.Destination)
		if err := os.WriteFile(dest, b, 0777); err != nil {
			if err := os.MkdirAll("./assets/images/"+strings.Replace(job.Destination, job.FileName, "", 1), 0777); err != nil {
				errs <- fmt.Errorf("mkdir \"./assets/images/%s\" failed: %v", err, job.Destination)
				return
			}
			if err := os.WriteFile(dest, b, 0777); err != nil {
				errs <- fmt.Errorf("write file failed: %v", err)
				return
			}
		}

		newFile := &filesPub{
			file: &files.FileRes{
				FileName: job.FileName,
				Url:      fmt.Sprintf("http://%s:%d/%s", u.cfg.App().Host(), u.cfg.App().Port(), job.Destination),
			},
			destination: job.Destination,
		}

		errs <- nil
		results <- newFile.file
	}
}

func (u *filesUsecase) UploadToStorage(req []*files.FileReq) ([]*files.FileRes, error) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*60)
	defer cancel()

	jobsCh := make(chan *files.FileReq, len(req))
	resultsCh := make(chan *files.FileRes, len(req))
	errsCh := make(chan error, len(req))

	res := make([]*files.FileRes, 0)

	for _, r := range req {
		jobsCh <- r
	}
	close(jobsCh)

	numWorkers := 5
	for i := 0; i < numWorkers; i++ {
		go u.uploadToStorageWorker(ctx, jobsCh, resultsCh, errsCh)
	}

	for a := 0; a < len(req); a++ {
		err := <-errsCh
		if err != nil {
			return nil, err
		}

		result := <-resultsCh
		res = append(res, result)
	}
	return res, nil
}
```
</li>
<li>
<p>Change usecase function in UploadFiles handler in filesHandler.go</p>

```go
func (h *filesHandler) UploadFiles(c *fiber.Ctx) error {
    ...
	res, err := h.filesUsecase.UploadToStorage(req)
	if err != nil {
		return entities.NewResponse(c).Error(
			fiber.ErrInternalServerError.Code,
			string(uploadErr),
			err.Error(),
		).Res()
	}
}
```
</li>
<li>
<p>Add this usecase in your files module in filesUsecase.go</p>

```go
func (u *filesUsecase) deleteFromStorageFileWorkers(ctx context.Context, jobs <-chan *files.DeleteFileReq, errs chan<- error) {
	for job := range jobs {
		if err := os.Remove("./assets/images/" + job.Destination); err != nil {
			errs <- fmt.Errorf("remove file: %s failed: %v", job.Destination, err)
			return
		}
		errs <- nil
	}
}

func (u *filesUsecase) DeleteFileOnStorage(req []*files.DeleteFileReq) error {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*60)
	defer cancel()

	jobsCh := make(chan *files.DeleteFileReq, len(req))
	errsCh := make(chan error, len(req))

	for _, r := range req {
		jobsCh <- r
	}
	close(jobsCh)

	numWorkers := 5
	for i := 0; i < numWorkers; i++ {
		go u.deleteFromStorageFileWorkers(ctx, jobsCh, errsCh)
	}

	for a := 0; a < len(req); a++ {
		err := <-errsCh
		return err
	}
	return nil
}
```
</li>
<li>

<p>Change usecase function in DeleteFile handler in filesHandler.go</p>

```go
func (h *filesHandler) DeleteFile(c *fiber.Ctx) error {
	...
	if err := h.filesUsecase.DeleteFileOnStorage(req); err != nil {
		return entities.NewResponse(c).Error(
			fiber.ErrInternalServerError.Code,
			string(deleteErr),
			err.Error(),
		).Res()
	}
}
```
</li>
</ol>