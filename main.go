package main

import (
	"database/sql"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/bootdotdev/learn-cicd-starter/internal/database"
	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

type apiConfig struct {
	DB *database.Queries
}

func main() {
	err := godotenv.Load(".env")
	if err != nil {
		log.Println("Warning: .env file not found, continuing with default environment")
	}

	portString := os.Getenv("PORT")
	if portString == "" {
		log.Fatal("PORT is not set in environment")
	}

	dbURL := os.Getenv("DB_URL")
	if dbURL == "" {
		log.Fatal("DB_URL is not set in environment")
	}

	conn, err := sql.Open("postgres", dbURL)
	if err != nil {
		log.Fatal("Can't connect to database:", err)
	}

	apiCfg := apiConfig{
		DB: database.New(conn),
	}

	router := http.NewServeMux()

	router.HandleFunc("GET /v1/healthz", handlerReadiness)
	router.HandleFunc("GET /v1/err", handlerErr)

	router.HandleFunc("POST /v1/users", apiCfg.handlerUsersCreate)

	router.HandleFunc("POST /v1/notes", apiCfg.handlerNotesCreate)
	router.HandleFunc("GET /v1/notes", apiCfg.handlerNotesGet)

	srv := &http.Server{
		Addr:         ":" + portString,
		Handler:      router,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 10 * time.Second,
	}

	log.Printf("Serving on port: %s\n", portString)
	err = srv.ListenAndServe()
	if err != nil {
		log.Fatal(err)
	}
}
