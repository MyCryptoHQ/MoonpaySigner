package main

import (
	"fmt"
	"os"
	"github.com/MyCryptoHQ/moonpaysigner/crypto"
)

func main(url string) {
	fmt.Println("url", url)
	secretKey := os.GetEnv("MOONPAY_SECRET_KEY")
	fmt.Println("secretKey", secretKey)
	signedMessage := crypto.SignMessage(url, secretKey)
	fmt.Println("signedMessage", signedMessage)
	return signedMessage
}