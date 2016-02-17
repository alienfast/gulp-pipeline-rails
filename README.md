# gulp-pipeline-rails

Remove Sprockets from Rails and use [gulp-pipleline](https://github.com/alienfast/gulp-pipeline).  Simpler, faster, and integrates very well with the rest of the assets community.

## Installation

Add this line to your application's Gemfile:

    gem 'gulp-pipeline-rails'

And then execute:

    $ bundle

## Usage

1. Remove sprockets from your `application.rb` and initialize Rails with `gulp-pipeline-rails`
    Depending on when you created your rails application, you may see one of the following.  Pick the one that fits best:

    1. Option one: using 'all'
    
        ```ruby
        # require 'rails/all'                 <== DELETE this line
        require 'gulp/pipeline/rails/all'     <== ADD this line
        ``` 
    1. Option two: individual inclusion of framework railties
    
        ```ruby
        # Pick the frameworks you want:
        require 'active_record/railtie'
        require 'action_controller/railtie'
        require 'action_mailer/railtie'
        require 'action_view/railtie'
        
        # require 'sprockets/railtie'          <== DELETE this line
        require 'gulp/pipeline/rails/railtie'  <== ADD this line
        ``` 
    
1. Remove unneeded gems such as: 
   - rails-jquery
   - rails-sass
   - uglifier
   
1. Remove unneeded `config.assets.*` configurations, simply leave `config.assets.debug` per environment.

1. Delete your old `public` and `tmp` folders.
   
1. Setup [gulp-pipleline](https://github.com/alienfast/gulp-pipeline) to generate your assets

2. Startup rails and you should be serving from your new asset pipeline!
    
## Goals
This gem is actually quite simple, and most of these goals are accomplished by the primary project [gulp-pipleline](https://github.com/alienfast/gulp-pipeline).  Nonetheless, if you are coming from rails, this is what to expect:

### Simple 
Ultimately this gem is simply serving static assets, we need nothing more complicated.  

### Easy
With very few configurations it is easy to understand and hard to go wrong.  The defaults should be good for almost everyone.  The only common config change is `config.assets.debug` based on the environment.  You usually delete all old `config.assets` and simply place this in your `application.rb`, it is likely what you want:

```ruby
config.assets.debug = %w(development).include?(Rails.env)
```

### Debugging
Sourcemaps.  You want them, we serve them. It's nothing complicated actually, you just need to ensure your [gulp-pipleline](https://github.com/alienfast/gulp-pipeline) is creating them (it does by default) and to make sure that your are running an environment that is configured as `config.assets.debug = true`.  If you use the snippet above, just run in `development` mode and you are good to go.

### Community Friendly 
Make it easy to use community assets, namely `npm` packages

### Engine aware 
[gulp-pipleline](https://github.com/alienfast/gulp-pipeline) and this gem should support engine configurations (at least yours).  Beware, if the engines depend on sprockets, we do not have a goal of supporting them.

### Performance
There should be no performance penalty for using [gulp-pipleline](https://github.com/alienfast/gulp-pipeline) and this gem, in fact, it should be generally faster for development and likely serving faster due to the decreased amount of work.  Static file serving from external servers should be unaffected and remain high performance.

### Remove Sprockets
We don't want to match Sprockets in functionality, but remove it from rails and provide simple static asset serving.  We want to remain something simpler; if you want something close to sprockets then I encourage you to engage there.  

## FAQ

### Can this serve assets that I compiled with _________ instead of `gulp-pipeline`?
Yes.  Just make sure your assets are generated into the `public` directory.  By default, we look for debug assets in `public/debug` as the file root, and non-debug assets in `public/digest`.  You can change the behavior/mapping/locations by taking a look at the configurations in [`railtie.rb`](https://github.com/alienfast/gulp-pipeline-rails/blob/master/lib/gulp/pipeline/rails/railtie.rb) and the resolution behavior in [`assets.rb`](https://github.com/alienfast/gulp-pipeline-rails/blob/master/lib/gulp/pipeline/rails/assets.rb).  With that said, don't look for us to put a lot of time and energy into supporting this, just submit PRs with your changes that pass test and be sure to add any new ones.
  
### You removed sprockets and replaced it with this? Are you nuts?
After trying to integrate with sprockets, we realized that there was nothing in sprockets that we actually needed.  For the most part, static file serving is easily done with `Rack::File` in [`server.rb`](https://github.com/alienfast/gulp-pipeline-rails/blob/master/lib/gulp/pipeline/rails/server.rb), and the only other real hook needed to customize rails (which sprockets also uses) is [`#compute_asset_path`](https://github.com/alienfast/gulp-pipeline-rails/blob/master/lib/gulp/pipeline/rails/helper.rb) which is expected by rails to be mixed in as a helper method.  It's ultimately a much smaller deal than we expected.   

## Contributing

1. Fork it ( https://github.com/[my-github-username]/gulp-pipeline-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
