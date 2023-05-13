![images_redis_large](https://user-images.githubusercontent.com/43048524/214068443-e99ead62-48e0-45e4-b0b9-cf7a05463377.png)

## Redis Cluster image
> Do NOT use this image in production environment!

This Docker image is intended for learning, CI setups and local development. You can use it to test Redis Cluster behaviour.

### Install
```sh
docker pull md03/redis-cluster
```

### Example setup with docker-compose with default values
Redis Cluster requires at least 6 nodes. Docker image by default runs 6 Redis nodes on ports: 6000,6001,6002,6003,6004 and 6005.

```yaml
services:
  mongodb:
    image: md03/redis-cluster
    restart: always
    ports:
      - '6000:6000'
      - '6001:6001'
      - '6002:6002'
      - '6003:6003'
      - '6004:6004'
      - '6005:6005'
    environment:
      - REDIS_NODES=6000,6001,6002,6003,6004,6005
      - REDIS_HOST=127.0.0.1
      - REDIS_REPLICAS=1
```

### License
Distributed under the MIT License.

