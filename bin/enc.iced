#!/usr/bin/env iced

cmd = require '../lib/command'
log = require '../lib/log'
fs   = require 'fs'
myfs = require '../lib/fs'
crypto = require 'crypto'
mycrypto = require '../lib/crypto'
base58 = require '../lib/base58'

#=========================================================================

class Command extends cmd.CipherBase
   
  #-----------------
   
  constructor : () ->
    super()

  #-----------------

  output_filename : () ->
    @argv.o or [ @infn, @file_extension() ].join ''

  #-----------------

  run : (cb) ->
    await @init defer ok
    if ok
      enc = new mycrypto.Encryptor { @stat, @pwmgr }
      await enc.init defer ok
      if not ok
        log.error "Could not setup encryption keys"
    if ok
      istream.pipe(enc).pipe(ostream)
      await istream.once 'end', defer()
      await ostream.once 'finish', defer()

    await @cleanup ok, defer()
    cb ok

#=========================================================================

cmd = new Command()
await cmd.run defer ok
process.exit if ok then 0 else -2

#=========================================================================

