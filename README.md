![](.github/images/repo_header.png)

[![Shlink](https://img.shields.io/badge/Shlink-4.5.3-blue.svg)](https://github.com/shlinkio/shlink/releases/tag/v4.5.3)
[![Dokku](https://img.shields.io/badge/Dokku-Repo-blue.svg)](https://github.com/dokku/dokku)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/d1ceward-on-dokku/shlink_on_dokku/graphs/commit-activity)

# Run Shlink on Dokku

## Overview

This guide explains how to deploy [Shlink](https://shlink.io/), a self-hosted URL shortener, on a [Dokku](http://dokku.viewdocs.io/dokku/) host. Dokku is a lightweight PaaS that simplifies deploying and managing applications using Docker.

## Prerequisites

Before proceeding, ensure you have the following:

- A working [Dokku host](http://dokku.viewdocs.io/dokku/getting-started/installation/).
- The [PostgreSQL plugin](https://github.com/dokku/dokku-postgres) installed on Dokku.
- (Optional) The [Let's Encrypt plugin](https://github.com/dokku/dokku-letsencrypt) for SSL certificates.

## Setup Instructions

### 1. Create the App

Log into your Dokku host and create the `shlink` app:

```bash
dokku apps:create shlink
```

### 2. Configure the App

#### Install, Create, and Link PostgreSQL Plugin

1. Install the PostgreSQL plugin:

    ```bash
    dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres
    ```

2. Create a PostgreSQL service:

    ```bash
    dokku postgres:create shlink
    ```

3. Link the PostgreSQL service to the app:

    ```bash
    dokku postgres:link shlink shlink
    ```

#### Set the Default Domain

Set the default domain for your Shlink instance:

```bash
dokku config:set shlink DEFAULT_DOMAIN=shlink.example.com
```

### 3. Configure the Domain and Ports

Set the domain for your app to enable routing:

```bash
dokku domains:set shlink shlink.example.com
```

Map the internal port `8080` to the external port `80`:
```bash
dokku ports:set shlink http:80:8080
```

### 4. Deploy the App

You can deploy the app to your Dokku server using one of the following methods:

#### Option 1: Deploy Using `dokku git:sync`

If your repository is hosted on a remote Git server with an HTTPS URL, you can deploy the app directly to your Dokku server using `dokku git:sync`. This method also triggers a build process automatically. Run the following command:

```bash
dokku git:sync --build shlink https://github.com/d1ceward-on-dokku/shlink_on_dokku.git
```

This will fetch the code from the specified repository, build the app, and deploy it to your Dokku server.

#### Option 2: Clone the Repository and Push Manually

If you prefer to work with the repository locally, you can clone it to your machine and push it to your Dokku server manually:

1. Clone the repository:

    ```bash
    # Via HTTPS
    git clone https://github.com/d1ceward-on-dokku/shlink_on_dokku.git
    ```

2. Add your Dokku server as a Git remote:

    ```bash
    git remote add dokku dokku@example.com:shlink
    ```

3. Push the app to your Dokku server:

    ```bash
    git push dokku master
    ```

Choose the method that best suits your workflow.

### 5. Enable SSL (Optional)

Secure your app with an SSL certificate from Let's Encrypt:

1. Add the HTTPS port:

     ```bash
     dokku ports:add shlink https:443:8080
     ```

2. Install the Let's Encrypt plugin:

    ```bash
    dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
    ```

3. Set the contact email for Let's Encrypt:

    ```bash
    dokku letsencrypt:set shlink email you@example.com
    ```

4. Enable Let's Encrypt for the app:

    ```bash
    dokku letsencrypt:enable shlink
    ```

## Wrapping Up

Congratulations! Your Shlink instance is now up and running. You can access it at [https://shlink.example.com](https://shlink.example.com).

For more information about Shlink, visit the [official documentation](https://shlink.io/documentation/).
