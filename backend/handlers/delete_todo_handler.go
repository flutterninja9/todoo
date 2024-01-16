package handlers

import (
	"net/http"

	"github.com/flutterninja9/todoo/backend/config"
	"github.com/flutterninja9/todoo/backend/db"
	"github.com/flutterninja9/todoo/backend/models"
	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

type DeleteTodoHandler struct {
	logger *logrus.Logger
	db     *db.Database
	config config.Config
}

func NewDeleteTodoHandler(logger *logrus.Logger, d *db.Database, c config.Config) *DeleteTodoHandler {
	return &DeleteTodoHandler{
		logger: logger,
		config: c,
		db:     d,
	}
}

func (l *DeleteTodoHandler) Handle(c *gin.Context) {
	id, ok := c.Params.Get("id")
	if !ok {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "unable to get id"})
		return
	}

	err := models.DeleteTodo(id, l.db, l.logger)
	if !ok {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Todo deleted",
	})
}
