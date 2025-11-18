package test

import (
	"fmt"
	"testing"

	"github.com/dath-251-thuanle/file-sharing-web-backend2/internal/domain"
	"github.com/dath-251-thuanle/file-sharing-web-backend2/internal/infrastructure/database"
	"github.com/dath-251-thuanle/file-sharing-web-backend2/internal/repository"
)

func TestCreateUser(t *testing.T) {
	name := "kdm"
	password := "bitch133"
	email := "kdm@gmail.com"
	enableTOTP := false

	database.InitDB()

	userrepo := repository.NewSQLUserRepository(database.DB)

	user := domain.User{
		Username:   name,
		Password:   password,
		Email:      email,
		EnableTOTP: enableTOTP,
	}
	err := userrepo.Create(&user)
	if err != nil {
		t.Errorf(`FAILED: %v`, err)
		return
	}

	founduser := domain.User{}
	err = userrepo.FindByEmail(email, &founduser)

	if err != nil {
		t.Errorf(`FAILED: %v`, err)
		return
	}

	fmt.Print(founduser)
}
