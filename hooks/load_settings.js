/**
 * Created on 2017/3/28.
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
    appendPreStartEnv = utils.appendPreStartEnv,
    tupperwareJson = utils.tupperwareJson;

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
    loadSettings
]);
