package servers

import (
	"github.com/Rayato159/kawaii-shop-tutorial/modules/products/productsHandlers"
	"github.com/Rayato159/kawaii-shop-tutorial/modules/products/productsRepositories"
	"github.com/Rayato159/kawaii-shop-tutorial/modules/products/productsUsecases"
)

type IProductsModule interface {
	Init()
	Repository() productsRepositories.IProductsRepository
	Usecase() productsUsecases.IProductsUsecase
	Handler() productsHandlers.IProductsHandler
}

type productsModule struct {
	*moduleFactory
	repository productsRepositories.IProductsRepository
	usecase    productsUsecases.IProductsUsecase
	handler    productsHandlers.IProductsHandler
}

func (m *moduleFactory) ProductsModule() IProductsModule {
	productsRepository := productsRepositories.ProductsRepository(m.s.db, m.s.cfg, m.FilesModule().Usecase())
	productsUsecase := productsUsecases.ProductsUsecase(productsRepository)
	productsHandler := productsHandlers.ProductsHandler(m.s.cfg, productsUsecase, m.FilesModule().Usecase())

	return &productsModule{
		moduleFactory: m,
		repository:    productsRepository,
		usecase:       productsUsecase,
		handler:       productsHandler,
	}
}

func (p *productsModule) Init() {
	router := p.r.Group("/products")

	router.Post("/", p.mid.JwtAuth(), p.mid.Authorize(2), p.handler.AddProduct)

	router.Patch("/:product_id", p.mid.JwtAuth(), p.mid.Authorize(2), p.handler.UpdateProduct)

	router.Get("/", p.mid.ApiKeyAuth(), p.handler.FindProduct)
	router.Get("/:product_id", p.mid.ApiKeyAuth(), p.handler.FindOneProduct)

	router.Delete("/:product_id", p.mid.JwtAuth(), p.mid.Authorize(2), p.handler.DeleteProduct)
}

func (f *productsModule) Repository() productsRepositories.IProductsRepository { return f.repository }
func (f *productsModule) Usecase() productsUsecases.IProductsUsecase           { return f.usecase }
func (f *productsModule) Handler() productsHandlers.IProductsHandler           { return f.handler }
