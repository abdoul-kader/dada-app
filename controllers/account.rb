# frozen_string_literal: true

require 'roda'

module Dada
  # Web controller for Dada API
  class App < Roda
    route('account') do |routing|
      routing.on do
        # GET /account/[username]
        routing.get String do |username|
          if @current_user && @current_user.username == username
            view '/account/account', locals: { current_user: @current_user }
          else
            routing.redirect '/auth/login'
          end
        end

        routing.on String do |token|
          routing.on 'registration_confirm' do
            # POST account/[token]/registration_confirm
            routing.post do
              passwords = Form::Passwords.call(routing.params)
              if passwords.failure?
                flash[:error] = Form.message_values(passwords)
                routing.redirect "/auth/#{token}/register"
              end

              new_account = SecureMessage.decrypt(token)
              CreateAccount.new(App.config).call(
                email: new_account['email'],
                username: new_account['username'],
                password: routing.params['password']
              )
              flash[:notice] = 'Account created! Please login'
              routing.redirect '/auth/login'
            rescue CreateAccount::InvalidAccount => error
              puts error.backtrace
              flash[:error] = error.message
              routing.redirect '/auth/register'
            rescue StandardError => error
              puts error.backtrace
              flash[:error] = error.message
              routing.redirect(
                "#{App.config.APP_URL}/auth/register/#{token}"
              )
            end
          end
          routing.on 'forget_password' do
            # POST account/[token]/forget_password
            routing.post do
              puts "5#{token}"
              passwords = Form::Passwords.call(routing.params)
              puts "6#{passwords}"
              if passwords.failure?
                flash[:error] = Form.message_values(passwords)
                routing.redirect "/auth/#{token}/forget_password"
              end

              current_email = SecureMessage.decrypt(token)
<<<<<<< HEAD

              ChangePassword.new(App.config).call(
                email: current_email['email'],
=======
              CreateAccount.new(App.config).call(
                email: new_account['email'],
                username: new_account['username'],
>>>>>>> 28937c21bf423263468358286a829f5c47c3e189
                password: routing.params['password']
              )
              flash[:notice] = 'Password Reset! Please login'
              routing.redirect '/auth/login'
            end
          end
        end
      end
    end
  end
end
