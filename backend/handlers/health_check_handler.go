package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

type HealthCheckHandler struct {
	logger *logrus.Logger
}

func NewHealthCheckHandler(logger *logrus.Logger) *HealthCheckHandler {
	return &HealthCheckHandler{
		logger: logger,
	}
}

func (l *HealthCheckHandler) Handle(c *gin.Context) {
	c.String(http.StatusOK, "OK")
}
