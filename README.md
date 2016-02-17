# gulp-pipeline-rails

Remove Sprockets from Rails and use [gulp-pipleline](https://github.com/alienfast/gulp-pipeline).  Simpler, faster, and integrates very well with the rest of the assets community.

## Installation

Add this line to your application's Gemfile:

    gem 'gulp-pipeline-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gulp-pipeline-rails

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
With very few configurations it is easy to understand and hard to go wrong.  The defaults should be good for almost everyone.  The only common config is `config.assets.debug` based on the environment.   

### Community Friendly 
Make it easy to use community assets, namely `npm` packages

### Engine aware 
[gulp-pipleline](https://github.com/alienfast/gulp-pipeline) and this gem should support engine configurations (at least yours).  Beware, if the engines depend on sprockets, we do not have a goal of supporting them.

### Performance
There should be no performance penalty for using [gulp-pipleline](https://github.com/alienfast/gulp-pipeline) and this gem, in fact, it should be generally faster for development.  Static file serving from external servers should be unaffected.

### Remove Sprockets
We don't want to match Sprockets in functionality, but remove it from rails and provide simple static asset serving.  We want to remain something simpler, if you want something close to sprockets then I encourage you to engage there and help them make their project better.  


## TODO
- Tests, primarily the `Gulp::Pipeline::Rails::Assets` class which contains asset resolution/path computation


## Contributing

1. Fork it ( https://github.com/[my-github-username]/gulp-pipeline-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
