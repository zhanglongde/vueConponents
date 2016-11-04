'use strict'

const gulp = require('gulp')
const config = require('./build/config.js')
const requireDir = require('require-dir')
const watch = require('gulp-watch')
requireDir('./build', { recurse: true })

gulp.task('default', () => {
  gulp.start('make')
  gulp.start('todo')
  gulp.start('watch')
})

gulp.task('watch', () => {
  gulp.watch(config.js.src, ['es5', 'es6', 'todo'])
})