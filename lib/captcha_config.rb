Captcha::Config.new(
  # Used for filename cipher
  :password => 'sxXsgf73-5',
  # Captcha colors
  :colors => {
    :background => '#ffffff',
    :font => '#728FA8'
  },
  # Number of captcha images to generate
  :count => RAILS_ENV == 'production' ? 500 : 10,
  # Where to write captchas
  :destination => "#{RAILS_ROOT}/public/images/captchas",
  # Generate new batch every day
  :generate_every => 24 * 60 * 60
)
