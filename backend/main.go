package main

import (
	"github.com/flutterninja9/todoo/backend/config"
	"github.com/gin-gonic/gin"
	"github.com/spf13/viper"
)

func main() {
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
	app.GET("/", func(ctx *gin.Context) {
		ctx.JSON(200, gin.H{
			"message": "OK",
		})
	})

	app.Run(appConfig.SERVER_PORT)
}
