package handlers

import (
	"net/http"

	"github.com/flutterninja9/todoo/backend/db"
	"github.com/flutterninja9/todoo/backend/models"
	"github.com/flutterninja9/todoo/backend/utils"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/sirupsen/logrus"
)

type RegisterRequest struct {
	FirstName string `form:"firstName" validate:"required"`
	LastName  string `form:"lastName" validate:"required"`
	Email     string `form:"email" validate:"required,email"`
	Password  string `form:"password"`
}

func (r *RegisterRequest) toEntity() *models.User {
	return &models.User{
		FirstName: r.FirstName,
		LastName:  r.LastName,
		Email:     r.Email,
		Password:  r.Password,
	}
}

type RegisterHandler struct {
	logger    *logrus.Logger
	validator validator.Validate
	database  *db.Database
}

func NewRegisterHandler(logger *logrus.Logger, v validator.Validate, d *db.Database) *RegisterHandler {
	return &RegisterHandler{
		logger:    logger,
		validator: v,
		database:  d,
	}
}

func (l *RegisterHandler) Handle(c *gin.Context) {
	user := new(RegisterRequest)
	c.Bind(user)
	err := l.validator.Struct(user)
	if err != nil || len(user.Password) < 6 {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Check if all the fields are correct and valid"})
		return
	}

	hashedPassword, err := utils.HashPassword(user.Password)
	if err != nil {
		l.logger.Warning("Unable to hash password", err)
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	user.Password = hashedPassword
	entity := user.toEntity()
	savedEntity, err := entity.Save(l.database)
	if err != nil {
		l.logger.Warning("Unable to save entity", err)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": savedEntity})
}
