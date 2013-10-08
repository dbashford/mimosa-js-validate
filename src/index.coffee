"use strict"

logger = require 'logmimosa'
esprima = require 'esprima'

exports.registration = (mimosaConfig, register) ->
  register ['add','update','buildFile'], 'afterCompile', _validateJS, mimosaConfig.extensions.javascript

_validateJS = (mimosaConfig, options, next) ->
  for file in options.files
    try
      parsed = esprima.parse file.outputFileText, {tolerant: true}
      unless parsed.errors.length is 0
        logger.error "Parsed errors occurred in [[ #{file.inputFileName} ]]"
        for error in parsed.errors
          logger.info error.message
    catch err
      logger.error "js-validate failed to parse [[ #{file.inputFileName} ]] Error:", err
  next()