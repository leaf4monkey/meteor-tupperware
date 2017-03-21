# chriswessels/meteor-tupperware

This is a base Docker image that allows you to bundle your [Meteor.js](https://www.meteor.com) application into a lean, production-ready Docker image that you can deploy across your containerised infrastructure.

[![Docker Repository on Quay.io](https://quay.io/repository/chriswessels/meteor-tupperware/status "Docker Repository on Quay.io")](https://quay.io/repository/chriswessels/meteor-tupperware)

It includes [Node.js](https://nodejs.org/) and your bundled application (with platform-correct native extensions where required by included npm modules). You can also configure meteor-tupperware to install PhantomJS and ImageMagick if these are dependencies of your application.

Please see the [CHANGELOG](https://github.com/chriswessels/meteor-tupperware/blob/master/CHANGELOG.md) for the latest bundled library versions and changes.

## Usage

### Quickstart

In your Meteor.js project directory, run the following command:

    curl https://raw.githubusercontent.com/chriswessels/meteor-tupperware/master/quickstart.sh > /tmp/quickstart.sh && bash /tmp/quickstart.sh

This script will write a `Dockerfile` and `.dockerignore` into your current directory, preconfigured as in **Manual Setup** below.

After running the quickstart script, and assuming you have Docker running, you can build an image of your Meteor.js app by running:

    docker build -t yourname/app .

#### Manual setup (skip if you used Quickstart)

Using meteor-tupperware is very simple. Create a `Dockerfile` in your Meteor project directory with the following contents:

    FROM    quay.io/chriswessels/meteor-tupperware

This base image contains build triggers that will run when you build your app image. These triggers will build your app, install any dependencies, and leave you with a lean, production-ready image.

You'll also need to create a `.dockerignore` file in your Meteor project directory (alongside the Dockerfile) with the following contents:

    .meteor/local
    packages/*/.build*
    packages/*/.npm*

This file instructs Docker not to copy build artifacts into the image as these will be rebuilt anyway.

Assuming you have Docker running, you can build an image of your Meteor.js app by running:

    docker build -t yourname/app .

## Running your app image

The root process of the image will be set to the Node.js entrypoint for your Meteor application, so you can pass runtime settings straight into `docker run -e`, or bake them into your image with `ENV` directives in your Dockerfile.

Node.js will listen on port 80 inside the container, but you can bind this to any port on the host. You can also specify a different internal port if you need to like this:

    FROM    quay.io/chriswessels/meteor-tupperware
    ENV     PORT=8080

Example of passing options into `docker run` at runtime:

    docker run --rm \
    -e ROOT_URL=http://yourapp.com \
    -e MONGO_URL=mongodb://url \
    -e MONGO_OPLOG_URL=mongodb://oplog_url \
    -p 8080:80 \
    yourname/app

This example will run your Meteor application configured to connect to Mongo at `mongodb://url`, the Mongo oplog at `mongodb://oplog_url`, and will listen on port `8080` on the host, with Meteor expecting the public address of your app to be `http://yourapp.com`.

Example of baking options into your image using your `Dockerfile` so you don't have to pass them in at runtime:

    FROM    quay.io/chriswessels/meteor-tupperware
    ENV     MONGO_URL="mongodb://url" MONGO_OPLOG_URL="mongodb://oplog_url" ROOT_URL="http://yourapp.com"

## Build configuration

meteor-tupperware supports a few build configuration options that can be modified by creating a `tupperware.json` file in your Meteor project directory, alongside your `Dockerfile`. After changing `tupperware.json` you will need to rebuild your image with `docker build` (as above).

Default configuration options:

```javascript
/* tupperware.json */
{
  "dependencies": {
    "phantomJs": false,
    "imageMagick": false
  },
  "preBuildCommands": [],
  "postBuildCommands": [],
  "buildOptions": {
    "mobileServerUrl": false,
    "additionalFlags": false
  }
}
```

### tupperware.json Schema

- dependencies
  - phantomJs: `true` or `false` (for installing PhantomJS)
  - imageMagick: `true` or `false` (for installing ImageMagick)
- preBuildCommands `[string]` (an array of commands to run before `meteor build`. Paths are relative to your app directory)
- postBuildCommands `[string]` (an array of commands to run after `meteor build`. Paths are relative to your app directory)
- buildOptions
  - mobileServerUrl: `false` or type `string` (for specifying a server URL if you have mobile clients via Cordova)
  - additionalFlags: `false` or type `string` (for passing additional command line flags to `meteor build`)

### Pre and post build commands

As above, you can use the `preBuildCommands` option in `tupperware.json` to specify a list of commands that should be run prior to `meteor build`. You can use `postBuildCommands` to specify a list of commands that should be run after. The commands are executed within your app directory (`/app` with the container image).

This can be useful for installing private smart packages for your Meteor app prior to building, or performing post build transformations/cleanup.

## Contributions

Contributions are welcomed and appreciated!

1. Fork this repository.
1. Make your changes, documenting your new code with comments.
1. Submit a pull request with a sane commit message.

Feel free to get in touch if you have any questions.

## License

Please see the `LICENSE` file for more information.
