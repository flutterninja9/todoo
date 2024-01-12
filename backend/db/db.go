package db

import (
	"context"
	"errors"

	"github.com/flutterninja9/todoo/backend/config"
	"github.com/sirupsen/logrus"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type Database struct {
	logger *logrus.Logger
	config *config.Config
	client *mongo.Client
}

func NewDatabase(l *logrus.Logger, c *config.Config) *Database {
	return &Database{
		logger: l,
		config: c,
	}
}

func (d *Database) Init() error {
	d.logger.Info("initializing db")
	serverAPI := options.ServerAPI(options.ServerAPIVersion1)
	opts := options.Client().ApplyURI(d.config.CONN_URL).SetServerAPIOptions(serverAPI)
	client, err := mongo.Connect(context.TODO(), opts)
	d.client = client
	d.logger.Info("client initialized and set succesfully")
	if err != nil {
		panic(err)
	}
	// Send a ping to confirm a successful connection
	var result bson.M
	if err := client.Database("admin").RunCommand(context.TODO(), bson.D{{Key: "ping", Value: 1}}).Decode(&result); err != nil {
		panic(err)
	}
	d.logger.Info("mongo DB connection successfull")

	return nil
}

func (d *Database) Dispose() error {
	if d.client == nil {
		return errors.New("no client specified in db")
	}

	d.logger.Info("disposing database")
	err := d.client.Disconnect(context.TODO())
	if err != nil {
		d.logger.Warning("error disposing database")
		return err
	}
	d.logger.Info("disposed database")
	return nil
}
