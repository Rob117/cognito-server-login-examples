Aws.config.update({
    region: 'ap-northeast-1',
    credentials: Aws::Credentials.new(ENV['AWS_KEY'], ENV['AWS_SECRET'])
                  })

Cognito = Aws::CognitoIdentityProvider::Client.new