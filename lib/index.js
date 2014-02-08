"use strict";
var esprima, _validateJS;

esprima = require('esprima');

exports.registration = function(mimosaConfig, register) {
  return register(['add', 'update', 'buildFile'], 'afterCompile', _validateJS, mimosaConfig.extensions.javascript);
};

_validateJS = function(mimosaConfig, options, next) {
  var err, error, file, parsed, _i, _j, _len, _len1, _ref, _ref1;
  _ref = options.files;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    file = _ref[_i];
    try {
      parsed = esprima.parse(file.outputFileText, {
        tolerant: true
      });
      if (parsed.errors.length !== 0) {
        mimosaConfig.log.error("Parsed errors occurred in [[ " + file.inputFileName + " ]]");
        _ref1 = parsed.errors;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          error = _ref1[_j];
          mimosaConfig.log.info(error.message);
        }
      }
    } catch (_error) {
      err = _error;
      mimosaConfig.log.error("js-validate failed to parse [[ " + file.inputFileName + " ]] Error:", err);
    }
  }
  return next();
};
