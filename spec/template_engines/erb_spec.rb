require 'spec_helper'

describe Foundry::TemplateEngines::ERB do
  it 'can evaluate an ERB template' do
    expect(subject.evaluate('<%= 1 * 2 * 3 %>')).to eq('6')
  end

  it 'will raise an error if evaluation of an ERB template fails' do
    expect { subject.evaluate('<%= 1/0 %>') }.to raise_error ZeroDivisionError
  end
end
