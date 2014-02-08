"use strict"

esprima = require 'esprima'

exports.registration = (mimosaConfig, register) ->
  register ['add','update','buildFile'], 'afterCompile', _validateJS, mimosaConfig.extensions.javascript

_validateJS = (mimosaConfig, options, next) ->
  for file in options.files
    try
      parsed = esprima.parse file.outputFileText, {tolerant: true}
      unless parsed.errors.length is 0
        mimosaConfig.log.error "Parsed errors occurred in [[ #{file.inputFileName} ]]"
        for error in parsed.errors
          mimosaConfig.log.info error.message
    catch err
      mimosaConfig.log.error "js-validate failed to parse [[ #{file.inputFileName} ]] Error:", err
  next()