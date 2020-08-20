devise_validate = false
pp devise_validate
activeadmin_validate = false
pp activeadmin_validate
tailwind_validate = false
pp tailwind_validate
bootstrap_validate = false
pp bootstrap_validate

devise_validate = true if yes?('Devise ?')
if devise_validate == true
  activeadmin_validate = true if yes?('Active Admin ?')
end

if yes?('Tailwind ?')
  tailwind_validate = true
elsif yes?('Bootstrap ?')
  bootstrap_validate = true
end
pp devise_validate
pp activeadmin_validate
pp tailwind_validate
pp bootstrap_validate

# GEMFILE
########################################

if devise_validate == true
  inject_into_file 'Gemfile', before: 'group :development, :test do' do
    <<~RUBY
    gem 'devise'

    RUBY
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
else
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
run 'cp -R /Users/mathieuleblond/Desktop/rails-stylesheets-perso app/assets/stylesheets'
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
run 'cp db/seeds.rb db/seeds/_seed.rb'
run 'rm db/seeds.rb'
run 'touch db/seeds.rb'
inject_into_file 'db/seeds.rb' do
  <<-RUBY
  puts 'Creating all the Seeds'

  Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
    load seed
  end

  puts 'Finished!'
  RUBY
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
  generate('devise', 'User')

  # # App controller
  # ########################################
  run 'rm app/controllers/application_controller.rb'
  file 'app/controllers/application_controller.rb', <<~RUBY
  class ApplicationController < ActionController::Base
    #{  "protect_from_forgery with: :exception\n" if Rails.version < "5.2"}  before_action :authenticate_user!
  end
  RUBY

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

    // ----------------------------------------------------
    // Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
    // WRITE YOUR OWN JS STARTING FROM HERE 👇
    // ----------------------------------------------------

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

  # Git
  ########################################
  git add: '.'
  git commit: "-m 'Initial commit with devise template from https://github.com/lewagon/rails-templates'"
  run 'hub create && git -u push origin master' if yes?("Create Github repo?")
  # Fix puma config
  gsub_file('config/puma.rb', 'pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }', '# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }')
end

