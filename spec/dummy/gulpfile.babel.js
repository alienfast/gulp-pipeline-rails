import {Preset, Clean, CleanDigest, Copy, CssNano, Images, Sass, RollupIife, ScssLint, EsLint, Rev, Uglify, Aggregate, parallel, series} from 'gulp-pipeline/src/index'

import stringify from 'stringify-object'
import gulp from 'gulp'
import findup from 'findup-sync'
const node_modules = findup('node_modules')

let preset = Preset.rails()

// When converting non-modular dependencies into usable ones using rollup-plugin-commonjs, if they don't have properly read exports add them here.
const namedExports = {}
//namedExports[`${node_modules}/corejs-typeahead/dist/bloodhound.js`] = ['Bloodhound']

const rollupConfig = {
  commonjs: {
    options: {
      namedExports: namedExports,
    }
  }
}

const js = new Aggregate(gulp, 'js',
  series(gulp,
    new EsLint(gulp, preset),
    new RollupIife(gulp, preset, {options: {dest: 'application.js'}}, rollupConfig)
  )
)

const css = new Aggregate(gulp, 'css',
  series(gulp,
    new ScssLint(gulp, preset),
    new Sass(gulp, preset)
  )
)

const defaultRecipes = new Aggregate(gulp, 'default',
  series(gulp,
    new Clean(gulp, preset),
    parallel(gulp,
      new Images(gulp, preset),
      js,
      css
    )
  )
)

// Create the production assets
const digest = new Aggregate(gulp, 'digest',
  series(gulp,
    new CleanDigest(gulp, preset),

    parallel(gulp,
      new Copy(gulp, preset, {
        task: { name: 'digest:copy'},
        source: {
          options: {cwd: preset.images.dest},
          glob: ['**/*', '!application.js', '!application.js.map', '!application.css']
        },
        dest: 'docs/dist/'
      }),
      new Uglify(gulp, preset, {debug: true, concat: {dest: 'application.js'}}),
      new CssNano(gulp, preset, {debug: true, minExtension: false })
    ),
    new Rev(gulp, preset)
  )
)

// default then digest
new Aggregate(gulp, 'build',
  series(gulp,
    defaultRecipes,
    digest
  )
)
