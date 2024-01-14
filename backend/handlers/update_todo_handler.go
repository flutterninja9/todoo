package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

type UpdateTodoHandler struct {
	logger *logrus.Logger
}

func NewUpdateTodoHandler(logger *logrus.Logger) *UpdateTodoHandler {
	return &UpdateTodoHandler{
		logger: logger,
	}
}

func (l *UpdateTodoHandler) Handle(c *gin.Context) {
	id, ok := c.Params.Get("id")
	if !ok {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "unable to get id"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"id": id,
	})
}
