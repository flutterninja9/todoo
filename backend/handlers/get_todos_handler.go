package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

type GetTodosHandler struct {
	logger *logrus.Logger
}

func NewGetTodosHandler(logger *logrus.Logger) *GetTodosHandler {
	return &GetTodosHandler{
		logger: logger,
	}
}

func (l *GetTodosHandler) Handle(c *gin.Context) {
	c.String(http.StatusOK, "OK")
}
