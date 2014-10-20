require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

require 'render_anywhere'

# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sample

  class ApasUtf8Sanitizer
    include RenderAnywhere

    SANITIZE_ENV_KEYS = %w(
      HTTP_REFERER
      PATH_INFO
      REQUEST_URI
      REQUEST_PATH
      QUERY_STRING
    )

    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        SANITIZE_ENV_KEYS.each do |key|
          string = env[key].to_s
          URI.parse(string)
          valid = URI.decode(string).force_encoding('UTF-8').valid_encoding?
          # Don't accept requests with invalid byte sequence
          # return [ 404, { }, [ 'Bad request' ] ] unless valid
          fail 'Bad request' unless valid
        end
        @app.call(env)
      rescue => ex
        # logger.error(ex)
        puts '# -------- ApasUtf8Sanitizer'
        puts ex.message
        puts ex.class
        render_format(404)
      end
    end

    def render_format(status)
      html = render :template => 'errors/error_404.html.erb', :layout => 'application'
      html

      content_type = 'text/html'
      [status, {'Content-Type' => "#{content_type}; charset=#{ActionDispatch::Response.default_charset}",
         'Content-Length' => html.bytesize.to_s}, [html]]
    end

    def include_helper(helper_name)
      set_render_anywhere_helpers(helper_name)
    end

    def set_instance_variable(var, value)
      set_instance_variable(var, value)
    end

    class RenderingController < RenderAnywhere::RenderingController
      # include custom modules here, define accessors, etc. For example:
      attr_accessor :current_user
      helper_method :current_user
    end
  end

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.middleware.insert 0, ApasUtf8Sanitizer
  end
end
