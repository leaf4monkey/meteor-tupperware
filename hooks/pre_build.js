/**
 * Created on 2017/3/25.
 * @fileoverview 请填写简要的文件说明.
 * @author joc (Chen Wen)
 */
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
        var cmd = 'export DFT_METEOR_SETTINGS=' + settings;
        child_process.exec(cmd, {
            cwd: copyPath
        }, _.partial(handleExecError, done, cmd, 'load settings.json'));
        log.info('Settings in settings.json registered.');
    } else {
        log.info('No settings.json found.');
        done();
    }
}

async.series([
    runPreBuildCommands,
    loadSettings
]);
