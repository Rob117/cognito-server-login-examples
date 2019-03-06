Aws.config.update({
    region: 'ap-northeast-1',
    credentials: Aws::Credentials.new('', '')
                  })

Cognito = Aws::CognitoIdentityProvider::Client.new