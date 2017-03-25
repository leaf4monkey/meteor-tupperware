/**
 * Created on 2017/3/25.
 * @fileoverview 请填写简要的文件说明.
 * @author joc (Chen Wen)
 */
"use strict";

var _ = require('lodash'),
    async = require('async'),
    child_process = require('child_process'),
    utils = require('./utils');

var copyPath = utils.copyPath;

var log = utils.log,
    handleExecError = utils.handleExecError,
    tupperwareJson = utils.tupperwareJson;

function runPostBuildCommands (done) {
    if (tupperwareJson.postBuildCommands.length > 0) {
        log.info('Running post-build commands...');

        var tasks = [];

        _.each(tupperwareJson.postBuildCommands, function (cmd, index) {
            tasks.push(function (done) {
                child_process.exec(cmd, {
                    cwd: copyPath
                }, _.partial(handleExecError, done, cmd, 'run post-build command'));
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

async.series([
    runPostBuildCommands
]);
