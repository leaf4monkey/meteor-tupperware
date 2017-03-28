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
    appendEnv = _.partial(utils.appendEnv, 'pre'),
    appendPreStartEnv = utils.appendPreStartEnv,
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

function selectMeteorVersion (done) {
    var versionRegex = new RegExp('^METEOR@(.*)\n', 'ig');

    var meteorReleaseString = fs.readFileSync(copyPath + '/.meteor/release');
    var matches = versionRegex.exec(meteorReleaseString);

    var meteorVersion = matches[1];

    if (meteorVersion && meteorVersion !== process.env.METEOR_RELEASE) {
        appendEnv('METEOR_RELEASE', meteorVersion);
        log.info('meteor version switched as "' + meteorVersion + '".');
    }
    done();
}

function setBuildFlags (done) {
    var additionalFlags = tupperwareJson.buildOptions.additionalFlags || '';

    if (additionalFlags) {
        appendEnv('ADDITIONAL_FLAGS', additionalFlags);
    }
    done();
}

function checkUser (done) {
    var user = tupperwareJson.runAsRoot ? 'root' : 'node';

    appendEnv('APP_RUNNING_USER', user);
    log.info('Application will run with user: ' + user + '.');
    done();
}

function loadSettings (done) {
    tupperwareJson.prodSettings = tupperwareJson.prodSettings || 'settings.json';
    log.info('Loading settings from ' + tupperwareJson.prodSettings);
    var settings;
    try {
        settings = require(copyPath + '/' + tupperwareJson.prodSettings);
        if (settings) {
            settings = JSON.stringify(settings).replace(/\$/g, '\$\$');
        }
    } catch (e) {
        console.log('It sames that ' + tupperwareJson.prodSettings + ' is not json-formatted.');
    }

    if (_.isString(settings) && settings.length) {
        appendPreStartEnv('METEOR_SETTINGS', settings);
        log.info('Settings in settings.json registered.');
    } else {
        log.info('No settings.json found.');
    }
    done();
}

async.series([
    runPreBuildCommands,
    selectMeteorVersion,
    setBuildFlags,
    checkUser,
    loadSettings
]);
