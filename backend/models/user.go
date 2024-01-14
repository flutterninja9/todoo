package models

import (
	"context"
	"errors"

	"github.com/flutterninja9/todoo/backend/constants"
	"github.com/flutterninja9/todoo/backend/db"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type User struct {
	Id        primitive.ObjectID `json:"id"`
	FirstName string             `bson:"first_name" json:"first_name"`
	LastName  string             `bson:"last_name" json:"last_name"`
	Email     string             `bson:"email" json:"email"`
	Password  string             `bson:"password" json:"-"`
}

func (u *User) Save(d *db.Database) (*User, error) {
	var collection = d.Client.Database(constants.TODOSDB).Collection(constants.USERSCOLL)
	count, err := collection.CountDocuments(context.TODO(), bson.M{"email": u.Email})
	if err != nil {
		return nil, err
	}

	if count > 0 {
		return nil, errors.New("User already exists")
	}

	res, err := collection.InsertOne(context.TODO(), u)
	if err != nil {
		return nil, err
	}
	u.Id = res.InsertedID.(primitive.ObjectID)
	return u, nil
}
