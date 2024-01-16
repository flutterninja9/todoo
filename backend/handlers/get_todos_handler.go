package handlers

import (
	"net/http"
	"time"

	"github.com/flutterninja9/todoo/backend/db"
	middleware "github.com/flutterninja9/todoo/backend/middlewares"
	"github.com/flutterninja9/todoo/backend/models"
	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type GetTodosHandler struct {
	logger *logrus.Logger
	db     *db.Database
}

func NewGetTodosHandler(logger *logrus.Logger, d *db.Database) *GetTodosHandler {
	return &GetTodosHandler{
		logger: logger,
		db:     d,
	}
}

func (l *GetTodosHandler) Handle(c *gin.Context) {
	var filters = map[string]any{}
	dayFilter := c.Request.URL.Query().Get("day")
	if dayFilter != "" {
		layout := "2006-01-02"
		filters["created_at"], _ = time.Parse(layout, dayFilter)
	}

	authData, exists := c.Get("authInfo")
	if !exists {
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "User unauthorised"})
		return
	}

	authInfo := authData.(*middleware.AuthInfo)
	userId := authInfo.Claims["user_id"].(string)
	primitiveId, _ := primitive.ObjectIDFromHex(userId)
	filters["user_id"] = primitiveId
	todos, err := models.GetTodosByUserID(l.db, l.logger, filters)
	if err != nil {
		l.logger.Fatal(err)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Unable to get todos"})
		return
	}

	if todos == nil {
		emptyArray := [0]int{}
		c.JSON(http.StatusOK, gin.H{"data": emptyArray, "count": len(todos)})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": todos, "count": len(todos)})
}
