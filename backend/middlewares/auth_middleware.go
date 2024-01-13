package middleware

import (
	"errors"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
)

// AuthInfo struct to store JWT token and its claims
type AuthInfo struct {
	Token  string
	Claims jwt.MapClaims
}

// AuthMiddleware is a Fiber middleware for extracting and decoding the JWT token from the Authorization header
func AuthMiddleware(c *gin.Context) {
	authHeader := c.Request.Header.Get("Authorization")
	bearerToken := ""

	if strings.HasPrefix(authHeader, "Bearer ") {
		bearerToken = strings.TrimPrefix(authHeader, "Bearer ")
	}

	// Decode the token
	token, err := jwt.Parse(bearerToken, func(token *jwt.Token) (interface{}, error) {
		// Make sure token's method matches the signing method you expect
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, errors.New("unexpected signing method")
		}
		// Use the secret key used to sign the token
		return []byte(os.Getenv("JWT_SECRET")), nil
	})

	if err != nil {
		http.Error(c.Writer, "invalid token", http.StatusUnauthorized)
	}

	claims, ok := token.Claims.(jwt.MapClaims)

	if !ok || !token.Valid {
		http.Error(c.Writer, "invalid token", http.StatusUnauthorized)
	}

	exp, ok := claims["exp"].(float64)
	if !ok {
		http.Error(c.Writer, "invalid token", http.StatusUnauthorized)
	}
	if int64(exp) < time.Now().Unix() {
		http.Error(c.Writer, "token expired", http.StatusUnauthorized)
	}

	authInfo := &AuthInfo{
		Token:  bearerToken,
		Claims: claims,
	}

	c.Set("authInfo", authInfo)

	c.Next()
}
