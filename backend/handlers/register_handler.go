package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

type RegisterHandler struct {
	logger *logrus.Logger
}

func NewRegisterHandler(logger *logrus.Logger) *RegisterHandler {
	return &RegisterHandler{
		logger: logger,
	}
}

func (l *RegisterHandler) Handle(c *gin.Context) {
	c.String(http.StatusOK, "OK")
}
