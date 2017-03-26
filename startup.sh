#!/bin/sh

openssl genrsa -out tsaroot.key 2048 -config openssl.cnf

echo "generating request"
openssl req -new -x509 -key tsaroot.key -out tsaroot.crt -config config/tsaroot.cnf

echo "generating TSA certificate key"
openssl genrsa -out tsa.key 2048 -config openssl.cnf

echo "generating TSA certificate request"
openssl req -new -key tsa.key -out tsa.csr -config config/tsa.cnf

echo "generating TSA certificate"
openssl x509 -req -days 730 -in tsa.csr -CA tsaroot.crt -CAkey tsaroot.key -set_serial 01 -out tsa.crt -extfile extKey.cnf
