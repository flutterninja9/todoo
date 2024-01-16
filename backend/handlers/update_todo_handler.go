package handlers

import (
	"net/http"

	"github.com/flutterninja9/todoo/backend/config"
	"github.com/flutterninja9/todoo/backend/db"
	"github.com/flutterninja9/todoo/backend/models"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/sirupsen/logrus"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type UpdateTodoRequest struct {
	Status  models.TodoStatus `validate:"required,oneof=pending started completed" json:"status"`
	Title   *string           `json:"title"`
	Content *string           `json:"content"`
}

func (u *UpdateTodoRequest) toEntity(id string) *models.Todo {
	entity := new(models.Todo)
	entity.ID, _ = primitive.ObjectIDFromHex(id)
	entity.Status = string(u.Status)

	if u.Title != nil && *u.Title != "" {
		entity.Title = *u.Title
	}

	if u.Content != nil && *u.Content != "" {
		entity.Content = *u.Content
	}

	return entity
}

type UpdateTodoHandler struct {
	logger   *logrus.Logger
	db       *db.Database
	config   config.Config
	validate validator.Validate
}

func NewUpdateTodoHandler(logger *logrus.Logger, d *db.Database, c config.Config, v validator.Validate) *UpdateTodoHandler {
	return &UpdateTodoHandler{
		logger:   logger,
		db:       d,
		config:   c,
		validate: v,
	}
}

func (l *UpdateTodoHandler) Handle(c *gin.Context) {
	id, ok := c.Params.Get("id")

	if !ok {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "unable to get id"})
		return
	}

	updateRequest := new(UpdateTodoRequest)
	err := c.Bind(updateRequest)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Check if all the form fields are correct"})
		return
	}

	validationErr := l.validate.Struct(updateRequest)
	if validationErr != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Check if all the form fields are correct"})
		return
	}

	entity := updateRequest.toEntity(id)
	updated := entity.UpdateTodo(id, l.db, l.logger)

	if updated != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Oops! something went wrong while updating"})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "todo updated",
	})
}
