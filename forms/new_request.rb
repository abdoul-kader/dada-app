# frozen_string_literal: true

require 'dry-validation'

module Dada
  module Form
    NewRequest = Dry::Validation.Params do
      FILENAME_REGEX = %r{^((?![&\/\\\{\}\|\t]).)*$}
      PATH_REGEX = /^((?![&\{\}\|\t]).)*$/

      configure do
        config.messages_file = File.join(__dir__, 'errors/new_request.yml')
      end

      required(:title).filled
      required(:description).filled

      required(:filename).filled(max_size?: 256, format?: FILENAME_REGEX)
      required(:relative_path).maybe(format?: PATH_REGEX)
      required(:description).maybe
      required(:content).filled
    end
  end
end