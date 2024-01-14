package handlers

import (
	"net/http"

	"github.com/flutterninja9/todoo/backend/config"
	"github.com/flutterninja9/todoo/backend/db"
	"github.com/flutterninja9/todoo/backend/models"
	"github.com/flutterninja9/todoo/backend/utils"
	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

type LoginRequest struct {
	Email    string `form:"email"`
	Password string `form:"password"`
}

type LoginHandler struct {
	logger *logrus.Logger
	config config.Config
	db     *db.Database
}

func NewLoginHandler(logger *logrus.Logger, c config.Config, d *db.Database) *LoginHandler {
	return &LoginHandler{
		logger: logger,
		config: c,
		db:     d,
	}
}

func (l *LoginHandler) Handle(c *gin.Context) {
	loginRequest := new(LoginRequest)
	err := c.Bind(loginRequest)
	if err != nil {
		l.logger.Warning("Bad login request")
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"error": "Please check email and password",
		})
		return
	}

	user, err := models.GetUserByEmail(loginRequest.Email, l.db)
	if err != nil {
		l.logger.Warning("Unable to get user with email:", loginRequest.Email)
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"error": "Please check email and password",
		})
		return
	}

	passwordsMatch := utils.CompareHashedPassword(loginRequest.Password, user.Password)

	if !passwordsMatch {
		l.logger.Warning("Passwords do not match")
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
			"error": "Please check email or password and retry",
		})
		return
	}

	token, err := utils.GenerateToken(*user, l.config)
	if err != nil {
		l.logger.Warning("Unable to generate token", err)
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"error": "Oops... something went wrong!",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Logged in succesfully",
		"token":   token,
	})
}
