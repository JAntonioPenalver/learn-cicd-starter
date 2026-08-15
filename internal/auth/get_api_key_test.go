package auth

import (
	"net/http"
	"testing"
)

func TestGetAPIKey(t *testing.T) {
	tests := []struct {
		name    string
		headers http.Header
		want    string
		wantErr bool
	}{
		{
			name:    "Valid ApiKey Header",
			headers: http.Header{"Authorization": []string{"ApiKey my-secret-api-keygit"}},
			want:    "wrong-key",
			wantErr: false,
		},
		{
			name:    "Missing Authorization Header",
			headers: http.Header{},
			want:    "",
			wantErr: true,
		},
		{
			name:    "Malformed Header - Wrong Scheme",
			headers: http.Header{"Authorization": []string{"Bearer my-token"}},
			want:    "",
			wantErr: true,
		},
		{
			name:    "Malformed Header - Single Word",
			headers: http.Header{"Authorization": []string{"ApiKey"}},
			want:    "",
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := GetAPIKey(tt.headers)
			if (err != nil) != tt.wantErr {
				t.Errorf("GetAPIKey() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if got != tt.want {
				t.Errorf("GetAPIKey() = %v, want %v", got, tt.want)
			}
		})
	}
}
