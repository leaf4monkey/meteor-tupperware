/**
 * Created on 2017/3/25.
 * @fileoverview 请填写简要的文件说明.
 * @author joc (Chen Wen)
 */
"use strict";

var fs = require('fs'),
    _ = require('lodash');

var copyPath = '/home/node/app';

var tupperwareJsonDefaults = {
    "preBuildCommands": [],
    "postBuildCommands": [],
    "buildOptions": {
        "additionalFlags": false
    },
    "runAsRoot": true
};

function extractTupperwareJson () {
    var tupperwareJson = {};
    /* Attempt to read in meteorbuilder.json file for settings */
    try {
        tupperwareJson = require(copyPath + '/meteorbuilder.json');
        log.info('Settings in meteorbuilder.json registered.');
    } catch (e) {
        log.info('No meteorbuilder.json found, using defaults.');
    }

    /* Patch object with defaults for anything undefined */
    return _.defaults(tupperwareJson, tupperwareJsonDefaults);
}

var log = {
    info: function () {
        var args = Array.prototype.slice.apply(arguments);
        args.splice(0, 0, '[-] ');
        return console.log.apply(console, args);
    },
    error: function () {
        var args = Array.prototype.slice.apply(arguments);
        args.splice(0, 0, '[!] ');
        return console.log.apply(console, args);
    }
};

function appendFile (file, data) {
    try {
        console.log('append cli: \n');
        fs.appendFileSync(file, '\n', 'utf8');
        fs.appendFileSync(file, data, 'utf8');
        fs.appendFileSync(file, '\n', 'utf8');
        console.log(data);
    } catch (e) {
        console.log('error occur:', e);
    }
}

function getExportCli (key, val) {
    return 'export \'' + [key, val].join('=') + '\'';
}

function appendEnv (name, key, val) {
    appendFile('/tmp/hooks/' + name + '_build_env_setup.sh', getExportCli(key, val));
}

function appendPreStartEnv (key, val) {
    var cli = 'if [ -z "$' + key + '" ]; then\n' +
    '    export \'' + key + '=' + val + '\'\n' +
    '    echo export ' + key + ' as preset val' +
    'fi';
    appendFile('/scripts/pre_start.sh', cli);
}

/* Utils */
function suicide () {
    log.info('Container build failed. meteor-builder is exiting...');
    process.exit(1);
}

function handleExecError(done, cmd, taskDesc, error, stdout, stderr) {
    if (! error) {
        done();
    } else {
        log.error('While attempting to ' + taskDesc + ', the command:', cmd);
        log.error('Failed with the exit code ' + error.code + '. The signal was ' + error.signal + '.');
        if (stdout) {
            log.info('The task produced the following stdout:');
            console.log(stdout);
        }
        if (stderr) {
            log.info('The task produced the following stderr:');
            console.log(stderr);
        }
        suicide();
    }
}

_.extend(exports, {
    appendEnv: appendEnv,
    appendPreStartEnv: appendPreStartEnv,
    copyPath: copyPath,
    tupperwareJson: extractTupperwareJson(),
    log: log,
    suicide: suicide,
    handleExecError: handleExecError
});