# Argus developement deployment

## Basic usage
Customize the environment file `.env`, then source it:

```console
$ source .env
```

Run compose:

```console
$ docker-compose up --build
```

## Connect to an existing IAM deployment
To connect the Argus deployment to IAM, specify into the compose file the IAM
network as external network:

```yaml
networks:
  default:
    external:
      name: iam_default
```
The run the compose as described above.
