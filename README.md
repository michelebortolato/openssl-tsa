# TO build a TSA with openssl

## Config file

see openssl_config

## Creating TSA keys and certs

### Root certificate

```
openssl genrsa -out tsaroot.key 2048 -config openssl.cnf
openssl req -new -x509 -key tsaroot.key -out tsaroot.crt -config config/tsaroot.cnf
```

### TSA Certificate 

create a file **extKey.ctl** with the extended keyusages into it:


> extendedKeyUsage = critical,timeStamping

```
openssl genrsa -out tsa.key 2048 -config openssl.cnf
openssl req -new -key tsa.key -out tsa.csr -config config/tsa.cnf
openssl x509 -req -days 730 -in tsa.csr -CA tsaroot.crt -CAkey tsaroot.key -set_serial 01 -out tsa.crt -extfile extKey.cnf

```

## Using it

### Creating a request 

Usually needs to be setted:

* no nonce
* sha 256 hash algorithm
* a policy id (expilicitally or using the config file alias)
* the chertificate chain into the response

Something like this:

>  openssl ts -query -data input/input_file.txt -sha256 -no_nonce -cert -config openssl.cnf -policy 1.3.76.36.1.1.41 -out input/request.tsq

### Sending the request to the tsa

> openssl ts -reply -config openssl.cnf -queryfile input/request.tsq -inkey tsa.key -signer tsa.crt -out input/response.tsr

### Verify the response

> openssl ts -verify -queryfile input/request.tsq -in input/response.tsr -CAfile tsaroot.crt -untrusted tsa.crt



