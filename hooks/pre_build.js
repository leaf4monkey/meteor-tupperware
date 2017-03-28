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

async.series([
    runPreBuildCommands,
    selectMeteorVersion,
    setBuildFlags,
    checkUser,
]);
