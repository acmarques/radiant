# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
require File.join(File.dirname(__FILE__), 'boot')

require 'radius'

Radiant::Initializer.run do |config|
  
  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :action_mailer ]

  # Only load the extensions named here, in the order given. By default all
  # extensions in vendor/extensions are loaded, in alphabetical order. :all
  # can be used as a placeholder for all extensions not explicitly named.
  # config.extensions = [ :all ]
  config.extensions = [ :help, :all ]

  config.gem "sanitize"
  config.gem "will_paginate"
  config.gem "coderay"
  config.gem 'imagesize', :lib => 'image_size'
  
  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random,
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_radiant_korzus_session',
    :secret      => 'a0b2ce3cf4ee39fef298d848e7ad98e7348caf4e'
  }

  # Comment out this line if you want to turn off all caching, or
  # add options to modify the behavior. In the majority of deployment
  # scenarios it is desirable to leave Radiant's cache enabled and in
  # the default configuration.
  #
  # Additional options:
  #  :use_x_sendfile => true
  #    Turns on X-Sendfile support for Apache with mod_xsendfile or lighttpd.
  #  :use_x_accel_redirect => '/some/virtual/path'
  #    Turns on X-Accel-Redirect support for nginx. You have to provide
  #    a path that corresponds to a virtual location in your webserver
  #    configuration.
  #  :entitystore => "radiant:tmp/cache/entity"
  #    Sets the entity store type (preceding the colon) and storage
  #   location (following the colon, relative to Rails.root).
  #    We recommend you use radiant: since this will enable manual expiration.
  #  :metastore => "radiant:tmp/cache/meta"
  #    Sets the meta store type and storage location.  We recommend you use
  #    radiant: since this will enable manual expiration and acceleration headers.
  config.middleware.use ::Radiant::Cache

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :cookie_store

  # Activate observers that should always be running
  config.active_record.observers = :user_action_observer

  # Make Active Record use UTC-base instead of local time
  config.time_zone = 'UTC'

  # Set the default field error proc
  config.action_view.field_error_proc = Proc.new do |html, instance|
    if html !~ /label/
      %{<span class="error-with-field">#{html} <span class="error">&bull; #{[instance.error_message].flatten.first}</span></span>}
    else
      html
    end
  end

  config.after_initialize do
    # Add new inflection rules using the following format:
    ActiveSupport::Inflector.inflections do |inflect|
      inflect.uncountable 'config'
    end
  end
end

Haml::Template.options[:format] = :html5
Haml::Template.options[:ugly] = true if ENV['RAILS_ENV'] == 'production'

Radiant::Config['code.processor'] = 'coderay'
Radiant::Config['comments.simple_spam_filter_required?'] = false


# The URL for the login form of your website.
Radiant::Config["Member.login_path"] = '/members'

# Members will be redirected here on successful login.
Radiant::Config["Member.home_path"] = '/news'  

# Everything under this path requires member login.
Radiant::Config["Member.root_path"] = 'news'

# This text will be rendered if the user fails to log in.
Radiant::Config["Member.failed_login"] = "Couldn't log you in!"

# This text will be rendered if the user succesfully logs in.
Radiant::Config["Member.succesful_login"] = "Logged in successfully!"

# This text will be rendered if the user succesfully logs out.
Radiant::Config["Member.succesful_logout"] = "You have been logged out!" 

# This text will be rendered if the page needs member access.
Radiant::Config["Member.need_login"] = "Member must be logged in!"