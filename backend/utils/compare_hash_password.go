package utils

import "golang.org/x/crypto/bcrypt"

// returns true of hashed and passed in passwords are same
func CompareHashedPassword(plainPass string, hashedPass string) bool {
	var err = bcrypt.CompareHashAndPassword([]byte(hashedPass), []byte(plainPass))

	return err == nil
}
