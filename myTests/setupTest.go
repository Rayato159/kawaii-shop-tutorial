package myTests

import (
	"encoding/json"

	"github.com/Rayato159/kawaii-shop-tutorial/modules/servers"

	"github.com/Rayato159/kawaii-shop-tutorial/config"
	"github.com/Rayato159/kawaii-shop-tutorial/pkg/databases"
)

func SetupTest() servers.IModuleFactory {
	cfg := config.LoadConfig("../.env.test")

	db := databases.DbConnect(cfg.Db())

	s := servers.NewServer(cfg, db)
	return servers.InitModule(nil, s.GetServer(), nil)
}

func CompressToJSON(obj any) string {
	result, _ := json.Marshal(&obj)
	return string(result)
}
