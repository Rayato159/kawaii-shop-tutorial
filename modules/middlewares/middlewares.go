package middlewares

type Role struct {
	Id    int    `db:"id"`
	Title string `db:"title"`
}
