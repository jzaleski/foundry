require 'spec_helper'
require 'foundry/loaders/uri'

describe Foundry::Loaders::Uri do
  subject { Foundry::Loaders::Uri }
  let(:request) { double }
  let(:response_body) { 'response_body' }
  let(:response) { double(:body => response_body) }
  let(:http) { double(:request => response) }
  let(:http_url) { 'http://foo.bar.com' }
  let(:https_url) { http_url.gsub(/\Ahttp:/, 'https:') }

  before do
    expect(Net::HTTP).to receive(:new) { http }
    expect(Net::HTTP::Get).to receive(:new) { request }
  end

  it 'can load from a HTTP endpoint' do
    expect(subject.load(http_url, {})).to eq(response_body)
  end

  it 'can load from a HTTPS endpoint' do
    expect(http).to receive_messages([:use_ssl=, :verify_mode=])
    expect(subject.load(https_url, {})).to eq(response_body)
  end

  it 'can load from a endpoint using basic-auth' do
    expect(request).to receive(:basic_auth)
    expect(subject.load(
      http_url, {
        :username => 'basic_auth_username',
        :password => 'basic_auth_password',
      }
    )).to eq(response_body)
  end
end
