package router

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
)

type AppRouter struct {
	engine *gin.Engine
}

func NewAppRouter(engine *gin.Engine) *AppRouter {
	return &AppRouter{
		engine: engine,
	}
}

func (a *AppRouter) Setup() {
	// healthcheck
	a.engine.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "OK")
	})

	// login
	a.engine.POST("/login", func(c *gin.Context) {
		c.String(http.StatusOK, "OK")
	})

	// register
	a.engine.POST("/register", func(c *gin.Context) {
		c.String(http.StatusOK, "OK")
	})

	// Get user todos
	a.engine.GET("/todos", func(c *gin.Context) {
		c.String(http.StatusOK, "OK")
	})

	// Create Todo
	a.engine.POST("/todos", func(c *gin.Context) {
		c.String(http.StatusOK, "OK")
	})

	// Update Todo
	a.engine.PATCH("/todos/:id", func(c *gin.Context) {
		id, ok := c.Params.Get("id")
		if !ok {
			c.Error(errors.New("unable to get id"))
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"id": id,
		})
	})

	// Delete Todo
	a.engine.DELETE("/todos/:id", func(c *gin.Context) {
		id, ok := c.Params.Get("id")
		if !ok {
			c.Error(errors.New("unable to get id"))
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"id": id,
		})
	})
}
