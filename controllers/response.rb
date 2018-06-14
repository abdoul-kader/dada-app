# frozen_string_literal: true

require 'roda'

module Dada
  # Web controller for Dada API
  class App < Roda
    route('response') do |routing|
      # GET /response/list
      routing.on 'list' do
        routing.on String do |req_id|
          routing.get do
            routing.redirect '/' unless @current_user
            view '/response/response_detail', 
                 locals: { current_user: @current_user }
          end
        end
      end

      routing.is 'export' do
        # GET /request/create
        routing.get do
          routing.redirect '/' unless @current_user
          view '/response/response_export', 
               locals: { current_user: @current_user }
        end
      end
    end
  end
end
