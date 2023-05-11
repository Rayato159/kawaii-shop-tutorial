package myTests

import "testing"

type testFindOneProduct struct {
	productId string
	isErr     bool
	expect    string
}

func TestFindOneProduct(t *testing.T) {
	tests := []testFindOneProduct{
		{
			productId: "P000099",
			isErr:     true,
			expect:    "get product failed: sql: no rows in result set",
		},
		{
			productId: "P000001",
			isErr:     false,
			expect:    `{"id":"P000001","title":"Coffee","description":"Just a food \u0026 beverage product","category":{"id":1,"title":"food \u0026 beverage"},"created_at":"2023-05-03T17:22:47.649985","updated_at":"2023-05-03T17:22:47.649985","price":150,"images":[{"id":"c580fe73-afb3-47d1-a9df-eed24fdaea9b","filename":"fb1_1.jpg","url":"https://i.pinimg.com/564x/4a/1c/4a/4a1c4a9755e4d3bdfcb45a1c3a58712f.jpg"},{"id":"43bcd3fa-6f7f-4251-b196-f30ad4ea625e","filename":"fb1_2.jpg","url":"https://i.pinimg.com/564x/4a/1c/4a/4a1c4a9755e4d3bdfcb45a1c3a58712f.jpg"},{"id":"77d9e690-b722-4039-b0fe-5f7d9af0e6b4","filename":"fb1_3.jpg","url":"https://i.pinimg.com/564x/4a/1c/4a/4a1c4a9755e4d3bdfcb45a1c3a58712f.jpg"}]}`,
		},
	}

	productsModule := SetupTest().ProductsModule()
	for _, test := range tests {
		if test.isErr {
			if _, err := productsModule.Usecase().FindOneProduct(test.productId); err.Error() != test.expect {
				t.Errorf("expect: %v, got: %v", test.expect, err.Error())
			}
		} else {
			result, err := productsModule.Usecase().FindOneProduct(test.productId)
			if err != nil {
				t.Errorf("expect: %v, got: %v", nil, err.Error())
			}
			if CompressToJSON(&result) != test.expect {
				t.Errorf("expect: %v, got: %v", CompressToJSON(&result), test.expect)
			}
		}
	}
}
