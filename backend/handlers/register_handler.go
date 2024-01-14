package handlers

import (
	"net/http"

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

type RegisterHandler struct {
	logger    *logrus.Logger
	validator validator.Validate
}

func NewRegisterHandler(logger *logrus.Logger, v validator.Validate) *RegisterHandler {
	return &RegisterHandler{
		logger:    logger,
		validator: v,
	}
}

func (l *RegisterHandler) Handle(c *gin.Context) {
	user := new(RegisterRequest)
	c.Bind(user)
	err := l.validator.Struct(user)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Check if all the fields are correct"})
		return
	}

	c.String(http.StatusOK, "OK")
}
