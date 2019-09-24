# frozen_string_literal: true

module API
  class CoreController < ApplicationController
    respond_to :json

    include StatusMessages
    include AuthenticationHelpers

    before_action :authenticate_api!
    before_action :current_user
    before_action :current_business
  end
end

# TODO: RESCUE from VersionCake::UnsupportedVersionError
