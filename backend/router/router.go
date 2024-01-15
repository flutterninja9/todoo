package router

import (
	"github.com/flutterninja9/todoo/backend/config"
	"github.com/flutterninja9/todoo/backend/db"
	"github.com/flutterninja9/todoo/backend/handlers"
	middleware "github.com/flutterninja9/todoo/backend/middlewares"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/sirupsen/logrus"
)

type AppRouter struct {
	logger      *logrus.Logger
	engine      *gin.Engine
	db          *db.Database
	config      config.Config
	validateor  validator.Validate
	login       handlers.LoginHandler
	register    handlers.RegisterHandler
	getTodos    handlers.GetTodosHandler
	createTodo  handlers.CreateTodoHandler
	updateTodo  handlers.UpdateTodoHandler
	deleteTodo  handlers.DeleteTodoHandler
	healthCheck handlers.HealthCheckHandler
}

func NewAppRouter(engine *gin.Engine, logger *logrus.Logger, d *db.Database, v validator.Validate, c config.Config) *AppRouter {
	return &AppRouter{
		engine:      engine,
		logger:      logger,
		db:          d,
		validateor:  v,
		config:      c,
		login:       *handlers.NewLoginHandler(logger, c, d),
		register:    *handlers.NewRegisterHandler(logger, v, d, c),
		getTodos:    *handlers.NewGetTodosHandler(logger, d),
		createTodo:  *handlers.NewCreateTodoHandler(logger, v, d, c),
		updateTodo:  *handlers.NewUpdateTodoHandler(logger),
		deleteTodo:  *handlers.NewDeleteTodoHandler(logger),
		healthCheck: *handlers.NewHealthCheckHandler(logger),
	}
}

func (a *AppRouter) Setup() {
	todos := a.engine.Group("/todos")
	todos.Use(func(c *gin.Context) {
		middleware.AuthMiddleware(c, a.config)
	})
	a.engine.GET("/", a.healthCheck.Handle)
	a.engine.POST("/login", a.login.Handle)
	a.engine.POST("/register", a.register.Handle)
	todos.GET("/", a.getTodos.Handle)
	todos.POST("/", a.createTodo.Handle)
	todos.PATCH("/:id", a.updateTodo.Handle)
	todos.DELETE("/:id", a.deleteTodo.Handle)
}
