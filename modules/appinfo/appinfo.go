package appinfo

type CategoryFilter struct {
	Title string `query:"title"`
}

type Category struct {
	Id    int    `db:"id" json:"id"`
	Title string `db:"title" json:"title"`
}
