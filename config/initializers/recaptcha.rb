Recaptcha.configure do |config|
  # For development/test, you can:
  # 1. Use dummy keys (reCAPTCHA will be disabled)
  # 2. Set real keys from environment variables
  # 3. Disable reCAPTCHA completely
  
  if Rails.env.production?
    # Production: use environment variables or credentials
    config.site_key = ENV['RECAPTCHA_SITE_KEY']
    config.secret_key = ENV['RECAPTCHA_SECRET_KEY']
  else
    # Development/Test: disable reCAPTCHA with dummy keys
    # These allow the form to render without validation
    config.site_key = '6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI'
    config.secret_key = '6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe'
    config.skip_verify_env << 'development'
    config.skip_verify_env << 'test'
  end
end
