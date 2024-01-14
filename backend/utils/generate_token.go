package utils

import (
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/flutterninja9/todoo/backend/config"
	"github.com/flutterninja9/todoo/backend/models"
)

func GenerateToken(u models.User, c config.Config) (string, error) {
	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	claims["user_id"] = u.Id
	claims["exp"] = time.Now().Add(time.Hour * 2)

	t, err := token.SignedString([]byte(c.JWT_SECRET))
	if err != nil {
		return "", err
	}

	return t, nil
}
