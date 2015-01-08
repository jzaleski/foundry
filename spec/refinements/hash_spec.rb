require 'spec_helper'

describe Hash do
  subject do
    {
      :A => nil,
      :B => nil,
      :C => nil,
      :D => nil,
    }
  end

  let(:keys) do
    [
      :A,
      :B,
      :C,
      :D,
    ]
  end

  let(:other) do
    {
      :E => nil,
      :F => nil,
      :G => nil,
      :H => nil,
    }
  end
  let(:other_keys) do
    [
      :E,
      :F,
      :G,
      :H,
    ]
  end

  let(:nested) do
    {
      :I => nil,
      :J => nil,
      :K => {
        :L => nil,
      },
    }
  end

  describe 'destructive' do
    describe 'deep_merge!' do
      it 'can merge two hashes' do
        expect(subject.deep_merge!(other)).to eq({
          :A => nil,
          :B => nil,
          :C => nil,
          :D => nil,
          :E => nil,
          :F => nil,
          :G => nil,
          :H => nil,
        })
        expect(subject.size).to eq(keys.size + other_keys.size)
      end

      it 'can merge nested hashes' do
        expect(subject.deep_merge!(nested)).to eq({
          :A => nil,
          :B => nil,
          :C => nil,
          :D => nil,
          :I => nil,
          :J => nil,
          :K => {
            :L => nil,
          },
        })
      end
    end

    describe 'without!' do
      it 'can filter one key' do
        expect(subject.without!(:A)).to eq({
          :B => nil,
          :C => nil,
          :D => nil,
        })
        expect(subject.size).to eq(keys.size - 1)
      end

      it 'can filter multiple keys' do
        expect(subject.without!(:A, :B)).to eq({
          :C => nil,
          :D => nil,
        })
        expect(subject.size).to eq(keys.size - 2)
      end

      it 'skips keys that do not exist' do
        expect(subject.without!(:E)).to eq({
          :A => nil,
          :B => nil,
          :C => nil,
          :D => nil,
        })
        expect(subject.size).to eq(keys.size)
      end
    end
  end

  describe 'non-destructive' do
    describe 'deep_merge' do
      it 'can merge two hashes' do
        expect(subject.deep_merge(other)).to eq({
          :A => nil,
          :B => nil,
          :C => nil,
          :D => nil,
          :E => nil,
          :F => nil,
          :G => nil,
          :H => nil,
        })
        expect(subject.size).to eq(keys.size)
      end

      it 'can merge nested hashes' do
        expect(subject.deep_merge(nested)).to eq({
          :A => nil,
          :B => nil,
          :C => nil,
          :D => nil,
          :I => nil,
          :J => nil,
          :K => {
            :L => nil,
          },
        })
        expect(subject.size).to eq(keys.size)
      end
    end

    describe 'without' do
      it 'can filter one key' do
        expect(subject.without(:A)).to eq({
          :B => nil,
          :C => nil,
          :D => nil,
        })
        expect(subject.size).to eq(keys.size)
      end

      it 'can filter multiple keys' do
        expect(subject.without(:A, :B)).to eq({
          :C => nil,
          :D => nil,
        })
        expect(subject.size).to eq(keys.size)
      end

      it 'skips keys that do not exist' do
        expect(subject.without(:E)).to eq({
          :A => nil,
          :B => nil,
          :C => nil,
          :D => nil,
        })
        expect(subject.size).to eq(keys.size)
      end
    end
  end
end
