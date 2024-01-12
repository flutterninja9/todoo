package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

type LoginHandler struct {
	logger *logrus.Logger
}

func NewLoginHandler(logger *logrus.Logger) *LoginHandler {
	return &LoginHandler{
		logger: logger,
	}
}

func (l *LoginHandler) Handle(c *gin.Context) {
	c.String(http.StatusOK, "OK")
}
