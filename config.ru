# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

ruby '2.5.1'
run Rails.application
