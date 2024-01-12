package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

type CreateTodoHandler struct {
	logger *logrus.Logger
}

func NewCreateTodoHandler(logger *logrus.Logger) *CreateTodoHandler {
	return &CreateTodoHandler{
		logger: logger,
	}
}

func (l *CreateTodoHandler) Handle(c *gin.Context) {
	c.String(http.StatusOK, "OK")
}
