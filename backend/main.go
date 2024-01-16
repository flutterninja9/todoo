package main

import (
	"github.com/flutterninja9/todoo/backend/config"
	"github.com/flutterninja9/todoo/backend/db"
	middleware "github.com/flutterninja9/todoo/backend/middlewares"
	"github.com/flutterninja9/todoo/backend/router"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
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

	db := db.NewDatabase(logger, appConfig)
	dbErr := db.Init()
	if dbErr != nil {
		logger.Panic(dbErr)
	}

	defer db.Dispose()
	app := gin.New()
	app.Use(middleware.CORSMiddleware())
	validator := validator.New(validator.WithRequiredStructEnabled())
	router := router.NewAppRouter(app, logger, db, *validator, *appConfig)
	router.Setup()
	app.Run(appConfig.SERVER_PORT)
}
