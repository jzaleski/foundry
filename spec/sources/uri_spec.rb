require 'spec_helper'

describe Foundry::Sources::URI do
  let(:domain) { 'foo.bar.com' }
  let(:relative_path) { 'config.yml' }

  let(:http_uri) { "#{http_root_path}/#{relative_path}" }
  let(:http_root_path) { "http://#{domain}" }
  let(:http_response_body) { 'http_response_body' }
  let(:http_opts) { {} }

  let(:https_uri) { "#{https_root_path}/#{relative_path}" }
  let(:https_root_path) { "https://#{domain}" }
  let(:https_response_body) { 'https_response_body' }
  let(:https_opts) { {} }

  let(:basic_auth_root_path) { http_root_path }
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
        http_root_path,
        relative_path,
        http_opts
      )
    ).to eq(http_response_body)
  end

  it 'can load from a HTTPS endpoint' do
    stub_request(:get, https_uri).to_return(:body => https_response_body)

    expect(
      subject.load(
        https_root_path,
        relative_path,
        https_opts
      )
    ).to eq(https_response_body)
  end

  it 'can load from a endpoint using basic-auth' do
    stub_request(:get, http_uri).to_return(:body => basic_auth_response_body)

    expect(
      subject.load(
        basic_auth_root_path,
        relative_path,
        basic_auth_opts
       )
    ).to eq(basic_auth_response_body)
  end
end
