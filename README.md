![](.github/images/repo_header.png)

[![Shlink](https://img.shields.io/badge/Shlink-4.4.6-blue.svg)](https://github.com/shlinkio/shlink/releases/tag/v4.4.6)
[![Dokku](https://img.shields.io/badge/Dokku-Repo-blue.svg)](https://github.com/dokku/dokku)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/d1ceward-on-dokku/shlink_on_dokku/graphs/commit-activity)
# Run Shlink on Dokku

## Perquisites

### What is Shlink?

[Shlink](https://shlink.io/) is a PHP-based self-hosted URL shortener that can be used to serve shortened URLs under your own domain.

### What is Dokku?

[Dokku](http://dokku.viewdocs.io/dokku/) is the smallest PaaS implementation you've ever seen - _Docker
powered mini-Heroku_.

### Requirements
* A working [Dokku host](http://dokku.viewdocs.io/dokku/getting-started/installation/)
* [PostgreSQL](https://github.com/dokku/dokku-postgres) plugin for Dokku
* [Letsencrypt](https://github.com/dokku/dokku-letsencrypt) plugin for SSL (optionnal)

# Setup

**Note:** Throughout this guide, we will use the domain `shlink.example.com` for demonstration purposes. Make sure to replace it with your actual domain name.

## Create the app

Log into your Dokku host and create the Shlink app:

```bash
dokku apps:create shlink
```

## Configuration

### Install, create and link PostgreSQL plugin

```bash
# Install postgres plugin on Dokku
dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres
```

```bash
# Create running plugin
dokku postgres:create shlink
```

```bash
# Link plugin to the main app
dokku postgres:link shlink shlink
```

### Setting default domain

```bash
dokku config:set shlink DEFAULT_DOMAIN=shlink.example.com
```

## Domain setup

To enable routing for the Shlink app, we need to configure the domain. Execute the following command:

```bash
dokku domains:set shlink shlink.example.com
```

## Push Shlink to Dokku

### Grabbing the repository

Begin by cloning this repository onto your local machine.

```bash
# Via SSH
git clone git@github.com:d1ceward-on-dokku/shlink_on_dokku.git

# Via HTTPS
git clone https://github.com/d1ceward-on-dokku/shlink_on_dokku.git
```

### Set up git remote

Now, set up your Dokku server as a remote repository.

```bash
git remote add dokku dokku@example.com:shlink
```

### Push Shlink

Now, you can push the Shlink app to Dokku. Ensure you have completed this step before moving on to the [next section](#ssl-certificate).

```bash
git push dokku master
```

## SSL certificate

Lastly, let's obtain an SSL certificate from [Let's Encrypt](https://letsencrypt.org/).

```bash
# Install letsencrypt plugin
dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git

# Set certificate contact email
dokku letsencrypt:set shlink email you@example.com

# Generate certificate
dokku letsencrypt:enable shlink
```

## Wrapping up

Congratulations! Your Shlink instance is now up and running, and you can access it at [https://shlink.example.com](https://shlink.example.com).
