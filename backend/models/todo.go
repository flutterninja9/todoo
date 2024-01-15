package models

import (
	"context"

	"github.com/flutterninja9/todoo/backend/config"
	"github.com/flutterninja9/todoo/backend/constants"
	"github.com/flutterninja9/todoo/backend/db"
	"github.com/sirupsen/logrus"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type Todo struct {
	Id        primitive.ObjectID `bson:"_id" json:"id"`
	UserId    primitive.ObjectID `bson:"user_id" json:"user_id"`
	Status    string             `bson:"status" json:"status"`
	Title     string             `bson:"title" json:"title"`
	Content   string             `bson:"content" json:"content"`
	CreatedAt primitive.DateTime `bson:"created_at" json:"created_at"`
	UpdatedAt primitive.DateTime `bson:"updated_at" json:"updated_at"`
}

func (t *Todo) Save(db *db.Database, l *logrus.Logger, c config.Config) error {
	l.Info("Trying to save ", t)
	collection := db.Client.Database(constants.TODOSDB).Collection(constants.TODOSCOLL)
	_, err := collection.InsertOne(context.TODO(), t)
	if err != nil {
		l.Warning("Error while saving todo", err)
		return err
	}
	l.Info("Todo created")
	return nil
}

type Todos []Todo
