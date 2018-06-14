# frozen_string_literal: true

require 'dry-validation'

module Dada
  module Form
    NewProject = Dry::Validation.Params do
      required(:title).filled
      required(:description).filled
      # optional(:repo_url).maybe(format?: URI::DEFAULT_PARSER.make_regexp)

      configure do
        config.messages_file = File.join(__dir__, 'errors/new_project.yml')
      end
    end
  end
end
