package utils

import (
	"fmt"
	"strings"
	"time"

	"github.com/google/uuid"
)

func RandFileName(ext string) string {
	filename := fmt.Sprintf("%s_%v", strings.ReplaceAll(uuid.NewString()[:6], "-", ""), time.Now().UnixMilli())
	if ext != "" {
		filename += fmt.Sprintf(".%s", ext)
	}
	return filename
}
