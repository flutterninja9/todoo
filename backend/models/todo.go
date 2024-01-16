// models package contains data models and functions for interacting with the database.

package models

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/flutterninja9/todoo/backend/config"
	"github.com/flutterninja9/todoo/backend/constants"
	"github.com/flutterninja9/todoo/backend/db"
	"github.com/sirupsen/logrus"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

// Todo represents a task in the system.
type Todo struct {
	ID        primitive.ObjectID `bson:"_id" json:"id"`
	UserID    primitive.ObjectID `bson:"user_id" json:"user_id"`
	Status    string             `bson:"status" json:"status"`
	Title     string             `bson:"title" json:"title"`
	Content   string             `bson:"content" json:"content"`
	CreatedAt time.Time          `bson:"created_at" json:"created_at"`
	UpdatedAt time.Time          `bson:"updated_at" json:"updated_at"`
}

// Save inserts a new Todo into the database.
func (t *Todo) Save(db *db.Database, l *logrus.Logger, c config.Config) error {
	l.Info("Trying to save ", t)
	collection := db.Client.Database(constants.TODOSDB).Collection(constants.TODOSCOLL)
	_, err := collection.InsertOne(context.TODO(), t)
	if err != nil {
		l.WithError(err).Error("Error while saving todo")
		return fmt.Errorf("error saving todo: %w", err)
	}
	l.Info("Todo created")
	return nil
}

// GetTodosByUserID retrieves all Todos associated with a given user ID.
func GetTodosByUserID(d *db.Database, l *logrus.Logger, filters map[string]any) ([]Todo, error) {
	l.Info("Trying to get todos with filters ", filters)
	collection := d.Client.Database(constants.TODOSDB).Collection(constants.TODOSCOLL)
	bsonFilters := bson.D{}
	for key, val := range filters {
		bsonFilters = append(bsonFilters, bson.E{Key: key, Value: val})
	}

	cursor, err := collection.Find(context.TODO(), bsonFilters)
	if err != nil {
		return nil, fmt.Errorf("error querying data: %w", err)
	}
	defer cursor.Close(context.TODO())

	var result []Todo
	if err := cursor.All(context.TODO(), &result); err != nil {
		return nil, fmt.Errorf("error setting data: %w", err)
	}

	l.Info("Total records:", len(result))
	return result, nil
}

// todoSaveableBson generates the BSON document for updating a Todo.
func (t *Todo) todoSaveableBson() primitive.D {
	updates := bson.D{{Key: "status", Value: t.Status}}
	updates = append(updates, bson.E{Key: "updated_at", Value: time.Now().UTC()})

	if t.Title != "" {
		updates = append(updates, bson.E{Key: "title", Value: t.Title})
	}

	if t.Content != "" {
		updates = append(updates, bson.E{Key: "content", Value: t.Content})
	}

	return updates
}

// UpdateTodo updates a Todo in the database.
func (t *Todo) UpdateTodo(id string, d *db.Database, l *logrus.Logger) error {
	l.Info("Trying to update todo")
	primitiveObjID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return fmt.Errorf("invalid Todo ID: %w", err)
	}

	filter := bson.M{"_id": primitiveObjID}
	updates := bson.D{{Key: "$set", Value: t.todoSaveableBson()}}

	collection := d.Client.Database(constants.TODOSDB).Collection(constants.TODOSCOLL)
	result, err := collection.UpdateOne(context.TODO(), filter, updates)
	if err != nil {
		return fmt.Errorf("unable to update todo: %w", err)
	}

	l.Printf("documents matched: %v\n", result.MatchedCount)
	l.Printf("documents updated: %v\n", result.ModifiedCount)

	return nil
}

// DeleteTodo deletes a Todo from the database.
func DeleteTodo(id string, d *db.Database, l *logrus.Logger) error {
	l.Info("Trying to delete todo")
	primitiveTodoID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return fmt.Errorf("invalid Todo ID: %w", err)
	}

	collection := d.Client.Database(constants.TODOSDB).Collection(constants.TODOSCOLL)
	result, err := collection.DeleteOne(context.TODO(), bson.M{"_id": primitiveTodoID})
	if err != nil {
		return fmt.Errorf("error deleting todo: %w", err)
	}

	if result.DeletedCount == 0 {
		return errors.New("no todo deleted")
	}

	l.Info("Deleted ", result.DeletedCount, " todos")
	return nil
}
