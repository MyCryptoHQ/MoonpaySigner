package main

import (
	"os"
	"context"
	"errors"
	"github.com/mycryptohq/moonpaysigner/crypto"
	"github.com/aws/aws-lambda-go/lambda"
)

type PostObjectReceived struct {
	UrlToSign string `json:"urlToSign"`
}

type PostObjectReturned struct {
	Signature string `json:"signature"`
	Success bool		`json:"success"`
}

func HandleRequest(ctx context.Context, postObject PostObjectReceived) (PostObjectReturned, error) {
	url := postObject.UrlToSign
	secretKey, success := os.LookupEnv("MOONPAY_SECRET_KEY")
	if success == false {
		return PostObjectReturned{
			Signature: "",
			Success: false}, errors.New("No MOONPAY_SECRET_KEY found.")
	}
	signedMessage := crypto.SignMessage(url, secretKey)
	return PostObjectReturned{
		Signature: signedMessage,
		Success: true}, nil
}

func main() {
	lambda.Start(HandleRequest)
}