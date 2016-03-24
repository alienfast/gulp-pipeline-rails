import {RailsRegistry} from 'gulp-pipeline/src/index'
import gulp from 'gulp'
import findup from 'findup-sync'

// When converting non-modular dependencies into usable ones using rollup-plugin-commonjs, if they don't have properly read exports add them here.  This is pretty common so I'll leave this sample here.
const node_modules = findup('node_modules')
const namedExports = {}
//namedExports[`${node_modules}/corejs-typeahead/dist/bloodhound.js`] = ['Bloodhound']


gulp.registry(new RailsRegistry({
  RollupIife: {
    commonjs: {
      options: {
        namedExports: namedExports,
      }
    }
  }
}))
