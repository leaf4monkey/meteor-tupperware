/**
 * Created on 2017/3/25.
 * @fileoverview 请填写简要的文件说明.
 * @author joc (Chen Wen)
 */
var _ = require('lodash');

var copyPath = '/home/node/app';

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
    copyPath: copyPath,
    log: log,
    suicide: suicide,
    handleExecError: handleExecError
});