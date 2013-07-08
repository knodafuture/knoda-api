# Some useful notes

===============================================================================

Some setup you must do manually if you haven't yet:

  1. Ensure you have defined default url options in your environments files. Here
     is an example of default_url_options appropriate for a development environment
     in config/environments/development.rb:

       config.action_mailer.default_url_options = { :host => 'localhost:3000' }

     In production, :host should be set to the actual host of your application.

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root :to => "home#index"

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

  4. If you are deploying Rails 3.1+ on Heroku, you may want to set:

       config.assets.initialize_on_precompile = false

     On config/application.rb forcing your application to not access the DB
     or load models when precompiling your assets.

  5. You can copy Devise views (for customization) to your app by running:

       rails g devise:views

===============================================================================


##################################################
#  NOTE FOR UPGRADING FROM PRE-3.0 VERSION       #
##################################################

Paperclip 3.0 introduces a non-backward compatible change in your attachment
path. This will help to prevent attachment name clashes when you have
multiple attachments with the same name. If you didn't alter your
attachment's path and are using Paperclip's default, you'll have to add
`:path` and `:url` to your `has_attached_file` definition. For example:

    has_attached_file :avatar,
      :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
      :url => "/system/:attachment/:id/:style/:filename"

