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
    appendFile = _.partial(utils.appendFile, 'pre'),
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

    console.log('type of settings:', typeof settings, 'len=', settings.length);
    console.log(settings);
    if (_.isString(settings) && settings.length) {
        appendFile('export \'DFT_METEOR_SETTINGS=' + settings + '\'');
        log.info('Settings in settings.json registered.');
    } else {
        log.info('No settings.json found.');
    }
    done();
}

function selectMeteorVersion (done) {
    var versionRegex = new RegExp('^METEOR@(.*)\n', 'ig');

    var meteorReleaseString = fs.readFileSync(copyPath + '/.meteor/release');
    var matches = versionRegex.exec(meteorReleaseString);

    var meteorVersion = matches[1];

    if (meteorVersion && meteorVersion !== process.env.METEOR_RELEASE) {
        log.info(meteorVersion, process.env.METEOR_RELEASE);
        appendFile('export METEOR_RELEASE="' + meteorVersion + '"');
        log.info('meteor version switched as "' + meteorVersion + '".');
    }
    done();
}

function setBuildFlags (done) {
    var additionalFlags = tupperwareJson.buildOptions.additionalFlags || '';

    if (additionalFlags) {
        appendFile('export ADDITIONAL_FLAGS="' + additionalFlags + '"');
    }
    done();
}

function checkUser (done) {
    var user = tupperwareJson.runAsRoot ? 'root' : 'node';

    appendFile('export APP_RUNNING_USER=' + user);
    log.info('Application will run with user: ' + user + '.');
    done();
}

async.series([
    runPreBuildCommands,
    loadSettings,
    selectMeteorVersion,
    setBuildFlags,
    checkUser
]);
