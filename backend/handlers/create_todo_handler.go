package handlers

import (
	"net/http"

	middleware "github.com/flutterninja9/todoo/backend/middlewares"
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
	iAuthInfo, exists := c.Get("authInfo")
	if !exists {
		c.Status(http.StatusUnauthorized)
	}

	authInfo := iAuthInfo.(*middleware.AuthInfo)

	c.JSON(http.StatusOK, gin.H{
		"authInfo": authInfo.Token,
	})
}
