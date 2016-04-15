browserify = require 'browserify'
coffee_reactify = require 'coffee-reactify'
gulp = require 'gulp'
gbrowserify = require 'gulp-browserify'
gconcat = require 'gulp-concat'
gnotify = require 'gulp-notify'
grename = require 'gulp-rename'
gsourcemaps = require 'gulp-sourcemaps'
gutil = require 'gulp-util'
source = require 'vinyl-source-stream'
watchify = require 'watchify'

paths =
  jsout: '../public/gen'

gulp.task 'compile', ->
  gulp.src('./src/app.cjsx', { read: false })
    .pipe(gbrowserify({
      transform: ['coffee-reactify'],
      extensions: ['.cjsx', '.coffee'],
      debug: true
    }))
    .pipe(grename('app.js'))
    .pipe(gulp.dest(paths.jsout))

gulp.task 'default', ['compile']
