import {Preset, Clean, CleanDigest, Images, MinifyCss, Sass, RollupIife, ScssLint, EsLint, Rev, TaskSeries} from 'gulp-pipeline'

// debug the project source - remove for repo
//import {Clean, CleanDigest, Images, MinifyCss, Sass, RollupIife, ScssLint, EsLint, Rev, TaskSeries} from 'gulp-pipeline'
//import Preset from '../../../gulp-pipeline/src/preset'

import stringify from 'stringify-object'
import gulp from 'gulp'
import findup from 'findup-sync'
const node_modules = findup('node_modules')


let preset = Preset.rails()

let eslint = new EsLint(gulp, preset)
let scsslint = new ScssLint(gulp, preset)

// When converting non-modular dependencies into usable ones using rollup-plugin-commonjs, if they don't have properly read exports add them here.
let namedExports = {}
//namedExports[`${node_modules}/corejs-typeahead/dist/bloodhound.js`] = ['Bloodhound']

let rollup = new RollupIife(gulp, preset, {
  options: {
    dest: 'application.js'
  },
  commonjs: {
    options: {
      namedExports: namedExports
    }
  }
})

let lint = [scsslint, eslint]

// instantiate ordered array of recipes (for each instantiation the tasks will be created e.g. sass and sass:watch)
let recipes = [
  new Clean(gulp, preset),
  lint,
  [
    new Images(gulp, preset),
    new Sass(gulp, preset),
    rollup
  ]
]

// Simple helper to create the default and watch tasks as a sequence of the recipes already defined
new TaskSeries(gulp, 'default', recipes)
new TaskSeries(gulp, 'lint', lint)
new TaskSeries(gulp, 'js', [eslint, rollup])


// Create the production assets
let digest = [
  new CleanDigest(gulp, preset),
  new Rev(gulp, preset),
  new MinifyCss(gulp, preset)
]
new TaskSeries(gulp, 'digest', digest)
