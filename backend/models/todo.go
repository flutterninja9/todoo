package models

import (
	"context"

	"github.com/flutterninja9/todoo/backend/config"
	"github.com/flutterninja9/todoo/backend/constants"
	"github.com/flutterninja9/todoo/backend/db"
	"github.com/sirupsen/logrus"
	"go.mongodb.org/mongo-driver/bson"
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

func GetTodosByUserId(id string, d *db.Database, l *logrus.Logger) ([]Todo, error) {
	l.Info("Trying to get todos for user ", id)
	collection := d.Client.Database(constants.TODOSDB).Collection(constants.TODOSCOLL)
	pUsrId, _ := primitive.ObjectIDFromHex(id)
	cursor, err := collection.Find(context.TODO(), bson.M{"user_id": pUsrId})
	if err != nil {
		l.Fatal("Some error occured while querying for data", err)
		return nil, err
	}

	defer cursor.Close(context.TODO())
	var result []Todo
	err = cursor.All(context.TODO(), &result)
	if err != nil {
		l.Fatal("Some error occured while setting data", err)
		return nil, err
	}

	l.Info("Total records:", len(result))
	return result, nil
}

// returns [true] if update request is successfull
func (t *Todo) UpdateTodo(i string, d *db.Database, l *logrus.Logger) bool {
	l.Info("Trying to update todo")
	primitiveObjId, _ := primitive.ObjectIDFromHex(i)
	l.Info(primitiveObjId)
	var filter = bson.D{{Key: "_id", Value: primitiveObjId}}
	var updates = bson.D{
		{
			Key: "$set",
			Value: bson.D{
				{Key: "status", Value: t.Status},
				{Key: "title", Value: t.Title},
				{Key: "content", Value: t.Content},
			},
		},
	}

	collection := d.Client.Database(constants.TODOSDB).Collection(constants.TODOSCOLL)
	var result, err = collection.UpdateOne(context.TODO(), filter, updates)
	if err != nil {
		l.Fatal("Unable to update todo: ", err.Error())
		return false
	}

	l.Printf("documents matched: %v\n", result.MatchedCount)
	l.Printf("documents updated: %v\n", result.ModifiedCount)

	return true
}
