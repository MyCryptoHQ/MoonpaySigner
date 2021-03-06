package main

import (
	"context"
	"encoding/json"
	"errors"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/mycryptohq/moonpaysigner/crypto"
	"log"
	"os"
)

type PostObjectReceived struct {
	UrlToSign string `json:"urlToSign"`
}
type PostObjectReturned struct {
	Signature string `json:"signature"`
	Success   bool   `json:"success"`
}

func HandleRequest(ctx context.Context, postObject events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	var req *PostObjectReceived
	err := json.Unmarshal([]byte(postObject.Body), &req)
	if err != nil {
		log.Println("Error unmarshalling object request body:", err)
	}
	url := req.UrlToSign
	secretKey, success := os.LookupEnv("MOONPAY_SECRET_KEY")
	if success == false {
		resp := PostObjectReturned{
			Signature: "",
			Success:   false,
		}
		r, _ := json.Marshal(resp)

		return events.APIGatewayProxyResponse{
			Headers: map[string]string{
				"X-Requested-With":             "*",
				"Access-Control-Allow-Headers": "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
				"Access-Control-Allow-Origin":  "*",
				"Access-Control-Allow-Methods": "POST,OPTIONS",
			},
			Body:       string(r),
			StatusCode: 400,
		}, errors.New("No MOONPAY_SECRET_KEY found.")
	}
	signedMessage := crypto.SignMessage(url, secretKey)
	resp := PostObjectReturned{
		Signature: signedMessage,
		Success:   true,
	}
	r, _ := json.Marshal(resp)
	response := events.APIGatewayProxyResponse{
		Headers: map[string]string{
			"X-Requested-With":             "*",
			"Access-Control-Allow-Headers": "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
			"Access-Control-Allow-Origin":  "*",
			"Access-Control-Allow-Methods": "POST,OPTIONS",
		},
		Body:       string(r),
		StatusCode: 200,
	}
	return response, nil
}
func main() {
	lambda.Start(HandleRequest)
}
