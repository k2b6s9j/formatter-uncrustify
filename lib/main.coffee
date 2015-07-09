module.exports = FormatterUncrustify =
  config:
    executablePath:
      title: 'Path to the exectuable'
      type: 'string'
      default: 'uncrustify'
    arguments:
      title: 'Arguments passed to the formatter'
      type: 'array'
      default: []

  provideFormatter: ->
    [
      {
        selector: '.source.c'
        getNewText: (text) -> @format(text, 'C')
      }
      {
        selector: '.source.cpp'
        getNewText: (text) -> @format(text, 'CPP')
      }
      {
        selector: '.source.objc'
        getNewText: (text) -> @format(text, 'OC')
      }
      {
        selector: '.source.objcpp'
        getNewText: (text) -> @format(text, 'OC+')
      }
      {
        selector: '.source.cs'
        getNewText: (text) -> @format(text, 'CS')
      }
      # {
      #   selector: '.source.d'
      #   getNewText: (text) -> @format text, 'D'
      # } if atom.packages.getLoadedPackages 'language-d'
      {
        selector: '.source.java'
        getNewText: (text) -> @format(text, 'JAVA')
      }
      # {
      #   selector: '.source.pwn'
      #   getNewText: (text) -> @format text, 'PAWN'
      # } if atom.packages.getLoadedPackages 'atom-language-pawn'
      # {
      #   selector: '.source.vala'
      #   getNewText: (text) -> @format text, 'VALA'
      # } if atom.packages.getLoadedPackages 'language-vala'
    ]

  format: (text, language) ->
    child_process = require 'child_process'
    return new Promise (resolve, reject) ->
      command = atom.config.get 'formatter-uncrustify.executablePath'
      args = atom.config.get 'formatter-uncrustify.arguments'
      args.push "-l #{language}" if language
      toReturn = []
      process = child_process.spawn(command, args, {})
      process.stdout.on 'data', (data) -> toReturn.push data
      process.stdin.write text
      process.stdin.end()
      process.on 'close', ->
        console.log toReturn.join('\n')
        resolve(toReturn.join('\n'))
