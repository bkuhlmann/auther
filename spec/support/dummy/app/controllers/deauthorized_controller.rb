# frozen_string_literal: true

# For testing purposes only.
class DeauthorizedController < ApplicationController
  def show
    render plain: "OK"
  end
end
