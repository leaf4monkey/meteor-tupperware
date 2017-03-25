/**
 * Created on 2017/3/25.
 * @fileoverview 请填写简要的文件说明.
 * @author joc (Chen Wen)
 */
"use strict";

var fs = require('fs'),
    _ = require('lodash'),
    async = require('async'),
    child_process = require('child_process'),
    utils = require('./utils');

var copyPath = utils.copyPath;

var log = utils.log,
    handleExecError = utils.handleExecError,
    tupperwareJson = utils.tupperwareJson;

function runPreBuildCommands (done) {
    if (tupperwareJson.preBuildCommands.length > 0) {
        log.info('Running pre-build commands...');

        var tasks = [];

        _.each(tupperwareJson.preBuildCommands, function (cmd) {
            tasks.push(function (done) {
                child_process.exec(cmd, {
                    cwd: copyPath
                }, _.partial(handleExecError, done, cmd, 'run pre-build command'));
            });
        });

        tasks.push(function () {
            done();
        });

        async.series(tasks);

    } else {
        done();
    }
}

function loadSettings (done) {
    log.info('Loading settings.json');
    var settings;
    try {
        settings = require(copyPath + '/settings.json');
        if (settings) {
            settings = JSON.stringify(settings).replace(/\$/g, '\$\$');
        }
    } catch (e) {
        console.log('It sames that settings.json is not good json-format');
    }

    if (_.isString(settings) && settings.length) {
        var cmd = 'export \'DFT_METEOR_SETTINGS=' + settings + '\'';
        child_process.exec(cmd, {
            cwd: copyPath
        }, _.partial(handleExecError, done, cmd, 'load settings.json'));
        log.info('Settings in settings.json registered.');
    } else {
        log.info('No settings.json found.');
        done();
    }
}

function selectMeteorVersion (done) {
    var versionRegex = new RegExp('^METEOR@(.*)\n', 'ig');

    var meteorReleaseString = fs.readFileSync(copyPath + '/.meteor/release');
    var matches = versionRegex.exec(meteorReleaseString);

    var meteorVersion = matches[1];

    log.info('Downloading Meteor ' + meteorVersion + ' Installer...');

    if (meteorVersion && meteorVersion !== process.env.METEOR_RELEASE) {
        log.info(meteorVersion, process.env.METEOR_RELEASE);
        var cmd = 'export METEOR_RELEASE=' + meteorVersion;
        child_process.exec(cmd, {
            cwd: copyPath
        }, _.partial(handleExecError, done, cmd, 'switch meteor version'));
        log.info('meteor version switched as "' + meteorVersion + '".');
    } else {
        done();
    }
}

function setBuildFlags (done) {
    var additionalFlags = tupperwareJson.buildOptions.additionalFlags || '';

    if (!additionalFlags) {
        return done();
    }
    var cmd = 'export ADDITIONAL_FLAGS="' + additionalFlags + '"';
    child_process.exec(cmd, {
        cwd: copyPath
    }, _.partial(handleExecError, done, cmd, 'concat additional flags'));
}

function checkUser (done) {
    var user = tupperwareJson.runAsRoot ? 'root' : 'node';

    var cmd = 'export APP_RUNNING_USER=' + user;
    child_process.exec(cmd, {
        cwd: copyPath
    }, _.partial(handleExecError, done, cmd, 'decide running user'));
}

async.series([
    runPreBuildCommands,
    loadSettings,
    selectMeteorVersion,
    setBuildFlags,
    checkUser
]);
