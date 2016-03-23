import {Preset, Clean, CleanDigest, Copy, CssNano, Images, Sass, RollupIife, ScssLint, EsLint, Rev, RevReplace, Uglify, Aggregate, parallel, series, tmpDir, sleep, clean} from 'gulp-pipeline/src/index'

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
const minifiedAssetsDir = tmpDir()
//console.log(`Using ******* ${minifiedAssetsDir}`)


// digests need to be one task, tmpDir makes things interdependent
const digests = {debug: true, task: false, watch: false}

const digest = new Aggregate(gulp, 'digest',
  series(gulp,
    new CleanDigest(gulp, preset, digests),

    // minify application.(css|js) to a tmp directory
    parallel(gulp,
      new Uglify(gulp, preset, digests, {dest: minifiedAssetsDir, concat: {dest: 'application.js'}}),
      new CssNano(gulp, preset, digests, {dest: minifiedAssetsDir, minExtension: false})
    ),

    // rev minified css|js from tmp
    new Rev(gulp, preset, digests, {
      source: {
        options: {
          cwd: minifiedAssetsDir
        }
      }
    }),
    // rev all the rest from the debug dir (except the minified application(css|js))
    new Rev(gulp, preset, digests, {
      source: {
        options: {
          ignore: ['**/application.js', '**/*.js.map', '**/application.css']
        }
      }
    }),
    new RevReplace(gulp, preset, digests)
  )
)

// default then digest
new Aggregate(gulp, 'build',
  series(gulp,
    defaultRecipes,
    digest
  )
)
