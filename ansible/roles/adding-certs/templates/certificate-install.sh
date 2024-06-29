#! /usr/bin/bash
# Download the certificates
sudo wget -O dwca-2018a.crt https://mirror.domain.com/cert1.pem
sudo wget -O dwauth2-2019a.crt https://mirror.domain.com/cert2.pem
 
# Validate the downloaded certificate - verify the certificate fingerprint matches the SHA256 fingerprint in the Getting the Certificate Files box at the top of this document
sudo openssl x509 -noout -fingerprint -sha256 -inform pem -in /usr/local/share/ca-certificates/extra/cert1.crt
 
sudo openssl x509 -noout -fingerprint -sha256 -inform pem -in /usr/local/share/ca-certificates/extra/cert2.crt

# Reconfigure the `ca-certificates` package:
sudo update-ca-certificates