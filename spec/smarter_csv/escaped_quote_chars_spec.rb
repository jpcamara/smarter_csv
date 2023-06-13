# frozen_string_literal: true

require 'spec_helper'

fixture_path = 'spec/fixtures'

describe 'handling files with escaped quote chars' do
  subject(:data) { SmarterCSV.process(file, options) }

  let(:options) { { acceleration: true } }

  describe ".count_quote_chars" do
    it "handles escaped characters and regular characters" do
      expect(SmarterCSV.count_quote_chars("\"No\" \"Escaping\"", "\"")).to eq 4
      expect(SmarterCSV.count_quote_chars("\"D\\\"Angelos\"", "\"")).to eq 2
      expect(SmarterCSV.count_quote_chars("\!D\\\!Angelos\!", "\!")).to eq 2
    end
  end

  context 'when it is a strangely delimited file' do
    let(:file) { "#{fixture_path}/escaped_quote_char.csv" }

    it 'loads the csv file without issues' do
      expect(data[0]).to eq(
        content: 'Some content',
        escapedname: "D\\\"Angelos",
        othercontent: "Some More Content"
      )
      expect(data[1]).to eq(
        content: 'Some content',
        escapedname: "O\\\"heard",
        othercontent: "Some More Content"
      )
      expect(data.size).to eq 2
    end
  end

  context 'when it is a strangely delimited file' do
    let(:file) { "#{fixture_path}/escaped_quote_char_2.csv" }
    let(:options) do
      { quote_char: "!" }
    end

    it 'loads the csv file without issues' do
      expect(data[0]).to eq(
        content: 'Some content',
        escapedname: "D\\\!Angelos",
        othercontent: "Some More Content"
      )
      expect(data[1]).to eq(
        content: 'Some content',
        escapedname: "O\\\!heard",
        othercontent: "Some More Content"
      )
      expect(data.size).to eq 2
    end
  end
end
