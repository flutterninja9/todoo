package models

import "go.mongodb.org/mongo-driver/bson/primitive"

type Todo struct {
	Id        primitive.ObjectID  `bson:"_id" json:"id"`
	UserId    primitive.ObjectID  `bson:"user_id" json:"user_id"`
	Status    string              `bson:"status" json:"status"`
	CreatedAt primitive.Timestamp `bson:"created_at" json:"created_at"`
	UpdatedAt primitive.Timestamp `bson:"updated_at" json:"updated_at"`
}

type Todos []Todo
