package handlers

import (
	"net/http"
	"time"

	"github.com/flutterninja9/todoo/backend/config"
	"github.com/flutterninja9/todoo/backend/db"
	middleware "github.com/flutterninja9/todoo/backend/middlewares"
	"github.com/flutterninja9/todoo/backend/models"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/sirupsen/logrus"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type CreateTodoRequest struct {
	Status  models.TodoStatus `form:"status" validate:"required,oneof=pending started completed"`
	Title   string            `form:"title" validate:"required"`
	Content string            `form:"content" validate:"required"`
}

func (c *CreateTodoRequest) toEntity(u string) (*models.Todo, error) {
	entity := new(models.Todo)
	entity.Title = c.Title
	entity.Content = c.Content
	entity.UserId, _ = primitive.ObjectIDFromHex(u)
	entity.Status = string(c.Status)
	entity.Id = primitive.NewObjectID()
	entity.CreatedAt = primitive.NewDateTimeFromTime(time.Now())
	entity.UpdatedAt = primitive.NewDateTimeFromTime(time.Now())

	return entity, nil
}

type CreateTodoHandler struct {
	db        *db.Database
	config    config.Config
	logger    *logrus.Logger
	validator validator.Validate
}

func NewCreateTodoHandler(logger *logrus.Logger, v validator.Validate, d *db.Database, c config.Config) *CreateTodoHandler {
	return &CreateTodoHandler{
		logger:    logger,
		validator: v,
		config:    c,
		db:        d,
	}
}

func (l *CreateTodoHandler) Handle(c *gin.Context) {
	iAuthInfo, exists := c.Get("authInfo")
	if !exists {
		c.AbortWithStatus(http.StatusUnauthorized)
	}

	authInfo := iAuthInfo.(*middleware.AuthInfo)
	var userId = authInfo.Claims["user_id"].(string)
	todoRequest := new(CreateTodoRequest)
	err := c.Bind(todoRequest)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}

	var validationErr = l.validator.Struct(todoRequest)
	if validationErr != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"error": validationErr.Error(),
		})
		return
	}
	entity, err := todoRequest.toEntity(userId)
	if validationErr != nil {
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
			"error": err.Error(),
		})
		return
	}

	err = entity.Save(l.db, l.logger, l.config)
	if validationErr != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Sucess",
		"data":    entity,
	})
}
