package main

import (
	"github.com/flutterninja9/todoo/backend/config"
	"github.com/flutterninja9/todoo/backend/router"
	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"
)

func main() {
	logger := logrus.New()
	appConfig := new(config.Config)
	viper := viper.New()
	viper.AddConfigPath(".")
	err := viper.ReadInConfig()
	if err != nil {
		panic(err)
	}

	decodeErr := viper.Unmarshal(appConfig)
	if decodeErr != nil {
		panic(decodeErr)
	}

	app := gin.New()
	router := router.NewAppRouter(app, logger)
	router.Setup()
	app.Run(appConfig.SERVER_PORT)
}
