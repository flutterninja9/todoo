package router

import (
	"github.com/flutterninja9/todoo/backend/handlers"
	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

type AppRouter struct {
	logger      *logrus.Logger
	engine      *gin.Engine
	login       handlers.LoginHandler
	register    handlers.RegisterHandler
	getTodos    handlers.GetTodosHandler
	createTodo  handlers.CreateTodoHandler
	updateTodo  handlers.UpdateTodoHandler
	deleteTodo  handlers.DeleteTodoHandler
	healthCheck handlers.HealthCheckHandler
}

func NewAppRouter(engine *gin.Engine, logger *logrus.Logger) *AppRouter {
	return &AppRouter{
		engine:      engine,
		logger:      logger,
		login:       *handlers.NewLoginHandler(logger),
		register:    *handlers.NewRegisterHandler(logger),
		getTodos:    *handlers.NewGetTodosHandler(logger),
		createTodo:  *handlers.NewCreateTodoHandler(logger),
		updateTodo:  *handlers.NewUpdateTodoHandler(logger),
		deleteTodo:  *handlers.NewDeleteTodoHandler(logger),
		healthCheck: *handlers.NewHealthCheckHandler(logger),
	}
}

func (a *AppRouter) Setup() {
	todos := a.engine.Group("/todos")

	a.engine.GET("/", a.healthCheck.Handle)
	a.engine.POST("/login", a.login.Handle)
	a.engine.POST("/register", a.register.Handle)
	todos.GET("/", a.getTodos.Handle)
	todos.POST("/", a.createTodo.Handle)
	todos.PATCH("/:id", a.updateTodo.Handle)
	todos.DELETE("/:id", a.deleteTodo.Handle)
}
