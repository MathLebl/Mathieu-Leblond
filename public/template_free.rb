# init variables
###########################################
variables = []
devise_validate = false
pundit_validate = false
activeadmin_validate = false
trestle_validate = false
tailwind_validate = false
bootstrap_validate = false
faker_validate = false
repo_validate = false
push_validate = false

# Setings Questions
###########################################
pp "Select your set up"
pp 'Front Options'
if yes?('Do you want to use Tailwind ?')
  tailwind_validate = true
  variables << tailwind_validate
elsif yes?('Do you want to use Bootstrap ?')
  bootstrap_validate = true
  variables << tailwind_validate
end

pp 'Authentication, Authorization and Back office options'
if yes?('Do you need some ?')
  devise_validate = true if yes?('Devise ?')
  if devise_validate == true
    variables << devise_validate
    if yes?('Pundit ?')
      pundit_validate = true
      variables << pundit_validate
    end
    if yes?('Do you want a back office ?')
      if yes?('Active Admin ?')
        activeadmin_validate = true
        variables << activeadmin_validate
      elsif yes?('Trestle ?')
        trestle_validate = true
        variables << trestle_validate
      end
    end
  end
end

pp 'Seeds Options'
if yes?('Do you need Faker ?')
  faker_validate = true
  variables << faker_validate
end

pp "Github repo and Heroku's options"
repo_validate = true if yes?("Create Github repo?")
if repo_validate == true
  variables << trestle_validate
  if yes?("Do you want to push to GitHub?")
    push_validate = true
    variables << push_validate
  end
  # if yes?('Create Heroku App')
  #   heroku_app_validate = true
  #   variables << heroku_app_validate
  # end
end

# GEMFILE
########################################

if devise_validate == true
  inject_into_file 'Gemfile', before: 'group :development, :test do' do
    <<~RUBY
    gem 'devise'

    RUBY
  end
  if pundit_validate == true
    inject_into_file 'Gemfile', before: 'group :development, :test do' do
      <<~RUBY
      gem 'pundit'

      RUBY
    end
  end
  if activeadmin_validate == true
    inject_into_file 'Gemfile', before: 'group :development, :test do' do
    <<~RUBY
    gem 'activeadmin'

    RUBY
    end
  elsif trestle_validate == true
    inject_into_file 'Gemfile', before: 'group :development, :test do' do
    <<~RUBY
    gem 'trestle'
    gem 'trestle-auth'

    RUBY
    end
  end
end

inject_into_file 'Gemfile', before: 'group :development, :test do' do
  <<~RUBY
  gem 'autoprefixer-rails'
  gem 'font-awesome-sass'

  RUBY
end
if bootstrap_validate == true
  inject_into_file 'Gemfile', before: 'group :development, :test do' do
    <<~RUBY
    gem 'simple_form'

    RUBY
  end
end
if faker_validate == true
  inject_into_file 'Gemfile', before: 'group :development, :test do' do
    <<~RUBY
    gem 'faker'

    RUBY
  end
end

inject_into_file 'Gemfile', before: 'group :development do' do
  <<-RUBY
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'dotenv-rails'

  RUBY
end

gsub_file('Gemfile', /# gem 'redis'/, "gem 'redis'")

# Create Services directory
########################################
run 'mkdir app/services'

# Stylesheets
########################################
run 'rm -rf app/assets/stylesheets'
run 'rm -rf vendor'
run 'curl -L http://www.mathieu-leblond.xyz/template_folder > stylesheets.zip'
run 'unzip stylesheets.zip -d app/assets && rm stylesheets.zip && mv app/assets/rails-stylesheets-perso app/assets/stylesheets'
if bootstrap_validate == true
  run 'touch app/assets/stylesheets/config/_bootstrap_variables.scss'
  prepend_file 'app/assets/stylesheets/application.scss', <<~RUBY
  // BOOTSTRAP
  @import "bootstrap/scss/bootstrap";
  @import "config/bootstrap_variables";

  RUBY
end
# Seeds
########################################
run 'mkdir db/seeds'
if devise_validate == true
  run 'touch db/seeds/user_seed.rb'
else
  run 'touch db/seeds/example_seed.rb'
end
run 'rm db/seeds.rb'
run 'touch db/seeds.rb'

inject_into_file 'db/seeds.rb' do
  <<-RUBY
  puts 'Creating all the Seeds'

  Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
    load seed
  end

  puts 'Finished!'

# run the seed files in db/seeds. Look at it
  RUBY
end

if faker_validate == true
  prepend_file 'db/seeds.rb', <<-RUBY
require 'faker'
  RUBY
end

if devise_validate == true
  inject_into_file 'db/seeds/user_seed.rb' do
    <<-RUBY
    puts 'Creating User ...'
    user = User.new(
      email: 'admin@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
    user.save!

    puts 'User created'
# Use the same technic for your seeds. Create a file in db/seeds and put your lines into.
    RUBY
  end
else
  inject_into_file 'db/seeds/example_seed.rb' do
    <<-RUBY
# Use the same technic for your seeds. Create a file in db/seeds and put your lines into.

  # puts 'Creating Example ...'
  # example = Example.new(
  #   param1: 'something',
  #   param2: 'somthing',
  #   param3_boolean: true
  # )
  # example.save!

  # puts 'Example seed created'

    RUBY
  end
end

# Dev environment
########################################
gsub_file('config/environments/development.rb', /config\.assets\.debug.*/, 'config.assets.debug = false')

# Generators
########################################
generators = <<~RUBY
config.generators do |generate|
  generate.assets false
  generate.helper false
  generate.test_framework :test_unit, fixture: false
end
RUBY

environment generators

########################################
# AFTER BUNDLE
########################################
after_bundle do
  # Generators: db + simple form + pages controller
  ########################################
  rails_command 'db:drop db:create db:migrate'
  generate('simple_form:install', '--bootstrap') if bootstrap_validate == true
  generate(:controller, 'pages', 'home', '--skip-routes', '--no-test-framework', '--force')

  # Routes
  ########################################
  route "root to: 'pages#home'"

  # Git ignore
  ########################################
  append_file '.gitignore', <<~TXT
  # Ignore .env file containing credentials.
  .env*
  # Ignore Mac and Linux file system files
  *.swp
  .DS_Store
  TXT

  if devise_validate == true
  # Devise install + user
  # ########################################
    generate('devise:install')
    generate('devise', 'User') if activeadmin_validate == false
    generate('pundit:install') if pundit_validate == true
    generate('active_admin:install', 'User') if activeadmin_validate == true
    generate('trestle:install') if trestle_validate == true
    generate('trestle:resource', 'User') if trestle_validate == true
    generate('trestle:auth:install', 'User', '--devise') if trestle_validate == true

  # # App controller
  # ########################################
  run 'rm app/controllers/application_controller.rb'
  file 'app/controllers/application_controller.rb', <<~RUBY
  class ApplicationController < ActionController::Base
    #{  "protect_from_forgery with: :exception\n" if Rails.version < "5.2"}  before_action :authenticate_user!
  end
  RUBY
  if pundit_validate == true
    inject_into_file 'app/controllers/application_controller.rb', after: 'before_action :authenticate_user!' do
      <<~RUBY

        include Pundit

      RUBY
    end
  end

  # # migrate + devise views
  # ########################################
  rails_command 'db:migrate'
  generate('devise:views')

  # # Pages Controller
  # ########################################
    run 'rm app/controllers/pages_controller.rb'
    file 'app/controllers/pages_controller.rb', <<~RUBY
    class PagesController < ApplicationController
    skip_before_action :authenticate_user!, only: [ :home ]

    def home
    end
  end
  RUBY
    if activeadmin_validate == true
      gsub_file 'db/seeds.rb', "User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?", ' '
      gsub_file 'config/initializers/active_admin.rb',
              '# config.site_title_link = "/"',
              'config.site_title_link = "/"'
    end
    rails_command 'db:seed'

  end
  # Environments
  ########################################
  environment 'config.action_mailer.default_url_options = { host: "http://localhost:3000" }', env: 'development'
  environment 'config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE" }', env: 'production'

  # Webpacker / Yarn
  ########################################
  run 'yarn add popper.js jquery bootstrap' if bootstrap_validate == true
  run 'yarn add tailwindcss list' if tailwind_validate == true
  run 'yarn tailwindcss init' if tailwind_validate == true


  if bootstrap_validate == true
  append_file 'app/javascript/packs/application.js', <<~JS

    // External imports
    import "bootstrap";

    // Internal imports, e.g:
    // import { initSelect2 } from '../components/init_select2';
    document.addEventListener('turbolinks:load', () => {
      // Call your functions here, e.g:
      // initSelect2();
    });
    JS

    inject_into_file 'config/webpack/environment.js', before: 'module.exports' do
      <<~JS
      const webpack = require('webpack');
      // Preventing Babel from transpiling NodeModules packages
      environment.loaders.delete('nodeModules');
      // Bootstrap 4 has a dependency over jQuery & Popper.js:
      environment.plugins.prepend('Provide',
      new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        Popper: ['popper.js', 'default']
      })
      );
      JS
    end
  end

  if tailwind_validate == true
    run 'mkdir app/javascript/stylesheets'
    run 'touch app/javascript/stylesheets/application.scss'
    append_file 'app/javascript/stylesheets/application.scss', <<~SCSS

    // import tailwindcss
    @import "tailwindcss/base";
    @import "tailwindcss/components";
    @import "tailwindcss/utilities";

    SCSS

    append_file 'app/javascript/packs/application.js', <<~JS

    require("stylesheets/application.scss")
    JS

    run 'rm postcss.config.js'
    file 'postcss.config.js', <<~JS
    module.exports = {
      plugins: [
        require('tailwindcss'),
        require('autoprefixer'),
        require('postcss-import'),
        require('postcss-flexbugs-fixes'),
        require('postcss-preset-env')({
          autoprefixer: {
            flexbox: 'no-2009'
          },
          stage: 3
        })
      ]
    }
JS
    inject_into_file 'tailwind.config.js', before: 'purge: [],' do
      <<~RUBY
      future: {
        removeDeprecatedGapUtilities: true,
      },
      RUBY
    end
  end

  # Dotenv
  ########################################
  run 'touch .env'

  # Fix puma config
  gsub_file('config/puma.rb', 'pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }', '# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }')
  # Git
  ########################################
  git add: '.'
  git commit: "-m 'Initial commit with modulable template from www.mathieu-leblond.xyz/templates'"
  run 'hub create && git -u push origin master' if repo_validate == true
  run 'git push origin master' if push_validate == true
  pp "You just create a new Rails app, #{app_name}, with"
  pp 'a naked version' if variables.empty? == true
  pp ' -> Devise' if devise_validate == true
  pp ' -> Pundit' if pundit_validate == true
  pp ' -> activeadmin' if activeadmin_validate == true
  pp ' -> trestle' if trestle_validate == true
  pp ' -> tailwind' if tailwind_validate == true
  pp ' -> bootstrap' if bootstrap_validate == true
  pp ' -> faker' if faker_validate == true
  pp ' -> Github repo' if repo_validate == true
  pp ' -> Git push origin master done' if push_validate == true
end
