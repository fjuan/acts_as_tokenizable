require 'spec_helper'

module ActsAsTokenizable
  describe StringUtils do
    describe '.numeric?' do
      it 'returns true with a float' do
        expect(described_class.numeric?('1.2')).to be_truthy
      end

      it 'returns true with an integer' do
        expect(described_class.numeric?('1')).to be_truthy
      end

      it 'returns true with a negative number' do
        expect(described_class.numeric?('-11')).to be_truthy
      end

      it 'returns false with a string' do
        expect(described_class.numeric?('1a')).to be_falsy
      end
    end

    describe '.words' do
      it 'splits a string into by word separators' do
        example = 'una mamá española aterrizó en Götemborg-int, Suecia.'

        expect(described_class.words(example))
          .to match_array %w(una mamá española aterrizó en Götemborg-int Suecia)
      end
    end

    describe '.remove_words' do
      it 'returns a string without the specified list of words' do
        sentence = 'a b c d e f g'
        words_to_remove = %w(c e f)
        expect(described_class.remove_words(sentence, words_to_remove, ' '))
          .to eq('a b d g')
      end

      it 'remove multiples occurences of a word' do
        sentence = 'a b a d a f g'
        words_to_remove = %w(a f)
        expect(described_class.remove_words(sentence, words_to_remove, ' '))
          .to eq('b d g')
      end
    end

    describe '.to_token' do
      it 'transforms tildes and letter modifications' do
        examples = {
          'mamá' => 'mama',
          'éxtasis' => 'extasis',
          'maría' => 'maria',
          'camión' => 'camion',
          'Úrsula' => 'ursula',
          'Umeå' => 'umea',
          'Gävle' => 'gavle',
          'Malmö' => 'malmo',
          'terraza' => 'teraza',
          'España' => 'espana'
        }

        examples.each do |string, expected_token|
          expect(described_class.to_token(string)).to eq(expected_token)
        end
      end

      it 'removes duplicate characters' do
        expect(described_class.to_token('terraza')).to eq('teraza')
      end
    end

    describe '.words_to_token' do
      it 'converts a string into something that can be used as an index key' do
        example = 'una mamá española aterrizó en Götemborg-int, Suecia.'

        expect(described_class.words_to_token(example))
          .to eq('una mama espanola aterizo en gotemborg-int suecia')
      end
    end
  end
end
