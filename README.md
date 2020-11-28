# nginx_ubuntu_docker

## nginx.conf

### 設定
- 設定ドメイン以外からのアクセスを弾く。
- wwwにリダイレクト。
- wwwとwwwなしの証明書、あるいはワイルドカード証明書を取得。
- httpsに転送される。

### conf
- example.comを置換すれば基本動く。

## ssl
- ドメインのフォルダを作り、そこに証明書を入れる。
- ドメインのDNS Aレコードの設定をしておくこと。
- DNS CAAが設定されているとDNS TXTレコードの確認で詰まるかも。

Lets Encrypt
```
certbot certonly --manual \
--server https://acme-v02.api.letsencrypt.org/directory \
--preferred-challenges dns \
-d *.example.com -d example.com \
-m mail@example.com \
--agree-tos \
--manual-public-ip-logging-ok
```

DNS CNAMEレコードの設定(wwwなしの場合は設定不要)  
`www CNAME 1h example.com.`

DNS TXTレコードの設定指示  
`_acme-challenge TXT 1h "XXXXXXXXX..."`

DNS TXTレコードの確認  
`nslookup -type=TXT _acme-challenge.example.com 8.8.8.8`  
設定が反映されたら進む。

DNS認証に成功したら、証明書の場所が表示される  
`/etc/letsencrypt/live/example.com/{fullchain.pem, privkey.pem}`

configuration/sslに証明書を入れる。

## Docker
### 構築
ビルド  
`docker build -t example.com .`

イメージ保存  
`docker save -o example.com.tar example.com`

イメージ読込  
`docker load -i example.com.tar`

コンテナの生成と起動  
`docker run -d -p 80:80 -p 443:443 --name example.com example.com:latest`

### イメージ・コンテナ操作  

起動  
`docker start [options] example.com`  
停止  
`docker stop [options] example.com`  
確認  
`docker stats example.com`  
コンテナ削除  
`docker rm example.com`  
イメージ削除  
`docker rmi example.com`