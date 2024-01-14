package models

type TodoStatus string

const (
	Pending   TodoStatus = "pending"
	Started   TodoStatus = "started"
	Completed TodoStatus = "completed"
)
