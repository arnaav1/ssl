cd /tmp
curl -Ls https://api.github.com/repos/xenolf/lego/releases/latest | grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4 | wget -i -
tar xf *.tar.gz
echo "list of packeges"
ls
echo "Please enter to continue"
read n4
sudo mkdir -p /opt/bitnami/letsencrypt
sudo mv lego /opt/bitnami/letsencrypt/lego
sudo /opt/bitnami/ctlscript.sh stop
echo "Please enter Email id:"
read Email
echo "Please enter domain:"
read Domain
sudo /opt/bitnami/letsencrypt/lego --tls --email="$Email" --domains="$Domain" --path="/opt/bitnami/letsencrypt" run
echo "Please enter to continue"
read n1
sudo mv /opt/bitnami/apache2/conf/server.crt /opt/bitnami/apache2/conf/server.crt.old
sudo mv /opt/bitnami/apache2/conf/server.key /opt/bitnami/apache2/conf/server.key.old
sudo mv /opt/bitnami/apache2/conf/server.csr /opt/bitnami/apache2/conf/server.csr.old
echo "Please enter to continue"
read n2
sudo ln -sf /opt/bitnami/letsencrypt/certificates/$Domain.key /opt/bitnami/apache2/conf/server.key
sudo ln -sf /opt/bitnami/letsencrypt/certificates/$Domain.crt /opt/bitnami/apache2/conf/server.crt
sudo chown root:root /opt/bitnami/apache2/conf/server*
sudo chmod 600 /opt/bitnami/apache2/conf/server*
echo "Please enter to start the service"
read n3
sudo /opt/bitnami/ctlscript.sh start

####renew certificate######



echo "sudo /opt/bitnami/ctlscript.sh stop apache" >> /opt/bitnami/letsencrypt/scripts/renew-certificate.sh
echo "sudo /opt/bitnami/letsencrypt/lego --tls --email="$Email" --domains="$Domain" --path="/opt/bitnami/letsencrypt" renew --days 90" >> /opt/bitnami/letsencrypt/scripts/renew-certificate.sh
echo "sudo /opt/bitnami/ctlscript.sh start apache" >> /opt/bitnami/letsencrypt/scripts/renew-certificate.sh

chmod +x /opt/bitnami/letsencrypt/scripts/renew-certificate.sh

#echo "0 0 1 * * sh /opt/bitnami/letsencrypt/scripts/renew-certificate.sh 2> /dev/null" | crontab -
(crontab -l 2>/dev/null || true; echo "0 0 1 * * sh /opt/bitnami/letsencrypt/scripts/renew-certificate.sh 2> /dev/null") | crontab -
