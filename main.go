package main

import (
	"database/sql"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/bootdotdev/learn-cicd-starter/internal/database"
	"github.com/go-chi/chi/"
	"github.com/go-chi/cors"
	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

type apiConfig struct {
	DB *database.Queries
}

func main() {
	err := godotenv.Load(".env")
	if err != nil {
		log.Println("Warning: .env file not found, continuing with environment variables")
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

	router := chi.NewRouter()

	router.Use(cors.Handler(cors.Options{
		AllowedOrigins:   []string{"https://*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"*"},
		ExposedHeaders:   []string{"Link"},
		MaxAge:           300,
		AllowCredentials: true,
	}))

	v1Router := chi.NewRouter()
	v1Router.Get("/healthz", handlerReadiness)
	v1Router.Get("/err", handlerErr)

	v1Router.Post("/users", apiCfg.handlerUsersCreate)

	v1Router.Post("/notes", apiCfg.middlewareAuth(apiCfg.handlerNotesCreate))
	v1Router.Get("/notes", apiCfg.middlewareAuth(apiCfg.handlerNotesGet))

	router.Mount("/v1", v1Router)

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
