package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

type DeleteTodoHandler struct {
	logger *logrus.Logger
}

func NewDeleteTodoHandler(logger *logrus.Logger) *DeleteTodoHandler {
	return &DeleteTodoHandler{
		logger: logger,
	}
}

func (l *DeleteTodoHandler) Handle(c *gin.Context) {
	id, ok := c.Params.Get("id")
	if !ok {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "unable to get id"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"id": id,
	})
}
