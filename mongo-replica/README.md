![images_mongo_large](https://user-images.githubusercontent.com/43048524/214068134-0f8c1fb8-408c-4081-9f5c-e9410aba5b82.png)

## MongoDB Replica Set image
> Do NOT use this image in production environment!

This Docker image is intended for learning, CI setups and local development. You can use it to test MongoDB transactions, change streams and more.

### Install
```shell
docker pull md03/mongo-replica
```

### Run replica set
By default, container will run replica set with single node on port `27017`
```shell
docker run -p 27017:27017 md03/mongo-replica
```
You can connect with URI:
```shell
mongodb://localhost:27017/?replicaSet=rs
```

### Example setup with docker-compose
```yaml
services:
  mongodb:
    image: md03/mongo-replica
    restart: always
    ports:
      - '4000:4000'
      - '4001:4001'
      - '4002:4002'
      - '4003:4003'
    environment:
      - MONGO_NODES=4000,4001,4002,4003
      - MONGO_HOST=localhost
      - REPLICA_SET=rs
```

Now you can connect to replica set with URI:
```yaml
mongodb://localhost:4000,localhost:4001,localhost:4002,localhost:40003/?replicaSet=rs
```

### Env variables and defaults
```shell
MONGO_NODES="27017"
MONGO_HOST="localhost"
REPLICA_SET="rs"
```

### License
Distributed under the MIT License.