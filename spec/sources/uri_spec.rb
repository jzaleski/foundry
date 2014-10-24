require 'spec_helper'

describe Foundry::Sources::URI do
  subject { Foundry::Sources::URI.new }
  let(:domain) { 'foo.bar.com' }
  let(:relative_path) { 'config.yml' }

  let(:http_uri) { "#{http_config_root}/#{relative_path}" }
  let(:http_config_root) { "http://#{domain}" }
  let(:http_response_body) { 'http_response_body' }
  let(:http_opts) { {} }

  let(:https_uri) { "#{https_config_root}/#{relative_path}" }
  let(:https_config_root) { "https://#{domain}" }
  let(:https_response_body) { 'https_response_body' }
  let(:https_opts) { {} }

  let(:basic_auth_uri) { "http://#{basic_auth_username}:#{basic_auth_password}@#{domain}/#{relative_path}" }
  let(:basic_auth_config_root) { http_config_root }
  let(:basic_auth_response_body) { 'basic_auth_response_body' }
  let(:basic_auth_username) { 'basic_auth_username' }
  let(:basic_auth_password) { 'basic_auth_password' }
  let(:basic_auth_opts) { { :username => basic_auth_username, :password => basic_auth_password } }

  before do
  end

  it 'can load from a HTTP endpoint' do
    stub_request(:get, http_uri).to_return(:body => http_response_body)

    expect(
      subject.load(
        http_config_root,
        relative_path,
        http_opts
      )
    ).to eq(http_response_body)
  end

  it 'can load from a HTTPS endpoint' do
    stub_request(:get, https_uri).to_return(:body => https_response_body)

    expect(
      subject.load(
        https_config_root,
        relative_path,
        https_opts
      )
    ).to eq(https_response_body)
  end

  it 'can load from a endpoint using basic-auth' do
    stub_request(:get, basic_auth_uri).to_return(:body => basic_auth_response_body)

    expect(
      subject.load(
        basic_auth_config_root,
        relative_path,
        basic_auth_opts
       )
    ).to eq(basic_auth_response_body)
  end
end
