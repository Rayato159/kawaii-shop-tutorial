package filesUsecases

import (
	"bytes"
	"context"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"time"

	"cloud.google.com/go/storage"
	"github.com/Rayato159/kawaii-shop-tutorial/config"
	"github.com/Rayato159/kawaii-shop-tutorial/modules/files"
)

type IFilesUsecase interface {
	UploadToGCP(req []*files.FileReq) ([]*files.FileRes, error)
}

type filesUsecase struct {
	cfg config.IConfig
}

type fileRes struct {
	bucket      string
	destination string
	file        *files.FileRes
}

func FilesUsecase(cfg config.IConfig) IFilesUsecase {
	return &filesUsecase{cfg: cfg}
}

func (f *fileRes) makePublic(ctx context.Context) error {
	client, err := storage.NewClient(ctx)
	if err != nil {
		return fmt.Errorf("storage.NewClient: %v", err)
	}
	defer client.Close()

	acl := client.Bucket(f.bucket).Object(f.destination).ACL()
	if err := acl.Set(ctx, storage.AllUsers, storage.RoleReader); err != nil {
		return fmt.Errorf("ACLHandle.Set: %v", err)
	}
	log.Printf("blob %v is now publicly accessible\n", f.destination)
	return nil
}

func (u *filesUsecase) uploadWorkers(ctx context.Context, client *storage.Client, jobs <-chan *files.FileReq, results chan<- *files.FileRes, errsCh chan<- error) {
	for job := range jobs {
		container, err := job.File.Open()
		if err != nil {
			errsCh <- err
			return
		}
		b, err := ioutil.ReadAll(container)
		if err != nil {
			errsCh <- err
			return
		}

		buf := bytes.NewBuffer(b)

		wc := client.Bucket(u.cfg.App().GCPBucket()).Object(job.Destination).NewWriter(ctx)

		if _, err = io.Copy(wc, buf); err != nil {
			errsCh <- fmt.Errorf("io.Copy: %v", err)
			return
		}

		if err := wc.Close(); err != nil {
			errsCh <- fmt.Errorf("Writer.Close: %v", err)
			return
		}
		log.Printf("%v uploaded to %v\n", job.FileName, job.Destination)

		newFile := &fileRes{
			file: &files.FileRes{
				Url:      fmt.Sprintf("https://storage.googleapis.com/%s/%s", u.cfg.App().GCPBucket(), job.Destination),
				FileName: job.FileName,
			},
			destination: job.Destination,
			bucket:      u.cfg.App().GCPBucket(),
		}

		if err := newFile.makePublic(ctx); err != nil {
			errsCh <- err
			return
		}

		results <- newFile.file
		errsCh <- nil
	}
}

func (u *filesUsecase) UploadToGCP(req []*files.FileReq) ([]*files.FileRes, error) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*60)
	defer cancel()

	client, err := storage.NewClient(ctx)
	if err != nil {
		return nil, fmt.Errorf("storage.NewClient: %v", err)
	}
	defer client.Close()

	jobsCh := make(chan *files.FileReq, len(req))
	resultsCh := make(chan *files.FileRes, len(req))
	errsCh := make(chan error, len(req))

	res := make([]*files.FileRes, 0)

	for _, f := range req {
		jobsCh <- f
	}
	close(jobsCh)

	numberWorkers := 5
	for i := 0; i < numberWorkers; i++ {
		go u.uploadWorkers(ctx, client, jobsCh, resultsCh, errsCh)
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
