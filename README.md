# MoonpaySigner

A Golang Moonpay.io signer 

#### Description:

Creates a moonpay signer with your secret key that exposes a CORS-enabled POST endpoint at **moonpay._[your_root_domain]_.com/sign**, to sign query-strings as specified in the moonpay.io/getting-started documentation

##### Requires:

`git`, `terraform`, `aws cli`

#### To Deploy:

1) `git clone https://github.com/mycryptohq/moonpaysigner.git`
2) `cd moonpaysigner`
3) `make deploy` -> builds the go app and zips it up.
4) `cd terraform && cp ex-tfvars.txt terraform.tfvars`-> copies the example tfvars file to a new tfvars file.
5) Change the new `terraform.tfvars`'s vars to include the correct secrey moonpay key and endpoint.
6) `terraform init`
7) `terraform apply`
8) Approve the cert validation for the new acm cert created for moonpay._[your_root_domain]_.com using [aws console](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-validate-dns.html) or cli.


Wha-bam. That should be all you need to do :-)
